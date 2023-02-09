part of zwap_tutorial_overlay;

typedef ZwapBetweenStepCallback = FutureOr<void> Function(int currentStep, bool reverse);
typedef InsertOverlayCallback = Function(OverlayEntry entry);

class ZwapTutorialController {
  /// Steps must be exactly the same lenght as the number of key generated with registerTutorialStep method
  ///
  /// Obviously the number provided in the registerTutorialStep methos must be the same od the index of the corrisponding step
  final List<ZwapTutorialStep> steps;

  /// This method will be called before pushin the new step
  ///
  /// The first parameter is the index of the new step
  ///
  /// The second parameter is true if the current step is before the previous one
  final ZwapBetweenStepCallback? betweenStepCallback;

  /// Used to insert the given entry in the Overlay of context
  ///
  /// Usually is something like that: `(entry) => Overlay.of(context)?.insert(entry);`
  final InsertOverlayCallback insertOverlayCallback;

  List<GlobalKey> _focusWidgetKeys = [];

  /// Contains the keys related to the same index [_focusWidgetKey]
  ///
  /// Those keys are used to blur only a region of the screen
  List<GlobalKey?> _blurRegionKeys = [];

  int? _currentStep;
  OverlayEntry? _entry;

  //? Why: We cannot know the order of the registerTutorialStep() methods, so we build save the steps
  //? in this map and build the real list only on when start method have been called
  Map<int, GlobalKey> _tmpKeys = {};

  ZwapTutorialController({required this.steps, this.betweenStepCallback, required this.insertOverlayCallback}) {
    this._blurRegionKeys = List.generate(steps.length, (index) => null);
  }

  void _buildFocusWidgetKeysList() {
    //? Check if the registered values and the steps list are compactible
    for (int i = 0; i < _tmpKeys.length; i++) {
      assert(_tmpKeys.containsKey(i)); //TODO: errore comprensibile
      _focusWidgetKeys.add(_tmpKeys[i]!);
    }
  }

  void start({int? startFrom}) {
    _buildFocusWidgetKeysList();

    assert(startFrom == null || startFrom < _focusWidgetKeys.length);

    _currentStep = startFrom ?? 0;
    final ZwapTutorialStep _firstStep = steps[_currentStep!];

    if (_entry != null) {
      if (_entry!.mounted) _entry!.remove();
      _entry = null;
    }

    _entry = ZwapTutorialOverlayEntry(
      uniqueKey: GlobalKey(),
      builder: (_) => ZwapComplexTutorialWidget(
        focusWidgetKey: _focusWidgetKeys[_currentStep!],
        child: _firstStep.content,
        backgroundColor: _firstStep.backgroundColor,
        height: _firstStep.height,
        onBack: _currentStep == 0 ? null : back,
        onClose: _firstStep.onClose,
        onForward: _currentStep! + 1 == steps.length ? end : forward,
        overlayOffset: _firstStep.overlayOffset,
        showBack: _currentStep != 0,
        showClose: _firstStep.showClose,
        showEnd: _currentStep! + 1 == steps.length,
        width: _firstStep.width,
        blurRegion: _blurRegionKeys[_currentStep!],
      ),
    );

    insertOverlayCallback(_entry!);
  }

  /// Return an unique global key and register this step
  GlobalKey<_ZwapTutorialOverlayWrapperState> registerTutorialStep(int stepNumber) {
    final GlobalKey<_ZwapTutorialOverlayWrapperState> _key = GlobalKey();
    _tmpKeys[stepNumber] = _key;
    return _key;
  }

  GlobalKey registerTutorialStepBackgroundRegion(int stepNumber) {
    final GlobalKey<_ZwapTutorialOverlayWrapperState> _key = GlobalKey();
    _blurRegionKeys[stepNumber] = _key;
    return _key;
  }

  Future forward() async {
    if (_currentStep == null || _currentStep! + 1 == steps.length) return;

    await goToStep(_currentStep! + 1);
  }

  Future back() async {
    if (_currentStep == null || _currentStep == 0) return;

    await goToStep(_currentStep! - 1);
  }

  /// Go to the given stepNumber step disposing the current step only if needed.
  ///
  /// The betweenStepCallback is called with the second paramenter as [reverse] (the second parameter of this methos)
  Future goToStep(int stepNumber, {bool reverse = false}) async {
    if (_entry != null) {
      final Duration _fadeDuration = (_entry as ZwapTutorialOverlayEntry).fadeOutDuration;
      _entry!.remove();
      await Future.delayed(_fadeDuration);
    }

    _currentStep = stepNumber;
    if (betweenStepCallback != null) await betweenStepCallback!(_currentStep!, reverse);

    final ZwapTutorialStep _nextStep = steps[_currentStep!];

    _entry = ZwapTutorialOverlayEntry(
      uniqueKey: GlobalKey(),
      builder: (_) => ZwapComplexTutorialWidget(
        focusWidgetKey: _focusWidgetKeys[_currentStep!],
        blurRegion: _blurRegionKeys[_currentStep!],
        child: _nextStep.content,
        backgroundColor: _nextStep.backgroundColor,
        height: _nextStep.height,
        onBack: _currentStep == 0 ? null : back,
        onClose: _nextStep.onClose,
        onForward: _currentStep! + 1 == steps.length ? end : forward,
        overlayOffset: _nextStep.overlayOffset,
        showBack: _currentStep != 0,
        showClose: _nextStep.showClose,
        showEnd: _currentStep! + 1 == steps.length,
        width: _nextStep.width,
      ),
    );

    insertOverlayCallback(_entry!);
  }

  Future end() async {
    if (_entry != null) {
      final Duration _fadeDuration = (_entry as ZwapTutorialOverlayEntry).fadeOutDuration;
      _entry!.remove();
      await Future.delayed(_fadeDuration);
    }

    _currentStep = null;
  }
}
