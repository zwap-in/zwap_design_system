part of zwap_tutorial_overlay;

typedef ZwapBetweenStepCallback = FutureOr<void> Function(int currentStep, bool reverse);
typedef InsertOverlayCallback = FutureOr<void> Function(OverlayEntry entry);

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
  InsertOverlayCallback? insertOverlayCallback;

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

  ZwapTutorialController({required this.steps, this.betweenStepCallback, this.insertOverlayCallback}) {
    this._blurRegionKeys = List.generate(steps.length, (index) => null);
  }

  void _buildFocusWidgetKeysList() {
    //? Check if the registered values and the steps list are compactible
    for (int i = 0; i < _tmpKeys.length; i++) {
      assert(_tmpKeys.containsKey(i)); //TODO: errore comprensibile
      _focusWidgetKeys.add(_tmpKeys[i]!);
    }
  }

  /// If [insertOverlay] is not null will be used instead of [insertOverlayCallback]
  ///
  /// [insertOverlay] must be not null if [insertOverlayCallback] is null
  void start({int? startFrom, InsertOverlayCallback? insertOverlay}) {
    assert(insertOverlay != null || insertOverlayCallback != null, "One of insertOverlay and insertOverlayCallback must be not null");
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
        index: _currentStep!,
        stepsCount: steps.length,
        focusWidgetKey: _focusWidgetKeys[_currentStep!],
        child: _firstStep.content,
        backgroundColor: _firstStep.backgroundColor,
        height: _firstStep.height,
        onBack: _currentStep == 0 ? null : back,
        onClose: () {
          if (_firstStep.onClose != null) _firstStep.onClose!();
          end();
        },
        onForward: _currentStep! + 1 == steps.length ? end : forward,
        overlayOffset: _firstStep.overlayOffset,
        showBack: _firstStep.showBack && _currentStep != 0,
        showSkip: _firstStep.showSkip,
        showEnd: _currentStep! + 1 == steps.length,
        width: _firstStep.width,
        blurRegion: _blurRegionKeys[_currentStep!],
        focusWidgetWrapper: _firstStep.focusWidgetWrapper,
        decorationDirection: _firstStep.decorationDirection,
        decorationTranslation: _firstStep.decorationTranslation,
      ),
    );

    _insertOverlay(_entry!, insertOverlay);
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

  GlobalKey registerTutorialStepBackgroundRegionFor(List<int> steps) {
    final GlobalKey<_ZwapTutorialOverlayWrapperState> _key = GlobalKey();
    for (int i in steps) _blurRegionKeys[i] = _key;
    return _key;
  }

  Future forward({InsertOverlayCallback? insertOverlay}) async {
    if (_currentStep == null || _currentStep! + 1 == steps.length) return;

    await goToStep(_currentStep! + 1, insertOverlay: insertOverlay);
  }

  Future back({InsertOverlayCallback? insertOverlay}) async {
    if (_currentStep == null || _currentStep == 0) return;

    await goToStep(_currentStep! - 1, insertOverlay: insertOverlay);
  }

  /// Go to the given stepNumber step disposing the current step only if needed.
  ///
  /// The betweenStepCallback is called with the second paramenter as [reverse] (the second parameter of this methos)
  Future goToStep(int stepNumber, {bool reverse = false, InsertOverlayCallback? insertOverlay}) async {
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
        index: _currentStep!,
        stepsCount: steps.length,
        focusWidgetKey: _focusWidgetKeys[_currentStep!],
        blurRegion: _blurRegionKeys[_currentStep!],
        child: _nextStep.content,
        backgroundColor: _nextStep.backgroundColor,
        height: _nextStep.height,
        onBack: _currentStep == 0 ? null : back,
        onClose: () {
          if (_nextStep.onClose != null) _nextStep.onClose!();
          end();
        },
        onForward: _currentStep! + 1 == steps.length ? end : forward,
        overlayOffset: _nextStep.overlayOffset,
        showBack: _nextStep.showBack && _currentStep != 0,
        showSkip: _nextStep.showSkip,
        showEnd: _currentStep! + 1 == steps.length,
        width: _nextStep.width,
        focusWidgetWrapper: _nextStep.focusWidgetWrapper,
        decorationDirection: _nextStep.decorationDirection,
        decorationTranslation: _nextStep.decorationTranslation,
      ),
    );

    _insertOverlay(_entry!, insertOverlay);
  }

  Future end() async {
    if (_entry != null) {
      final Duration _fadeDuration = (_entry as ZwapTutorialOverlayEntry).fadeOutDuration;
      _entry!.remove();
      await Future.delayed(_fadeDuration);
    }

    _currentStep = null;
  }

  void _insertOverlay(OverlayEntry entry, InsertOverlayCallback? insertOverlay) {
    if (insertOverlay != null) {
      insertOverlay(entry);
      insertOverlayCallback = insertOverlay;
      return;
    }
    insertOverlayCallback!(entry);
  }
}
