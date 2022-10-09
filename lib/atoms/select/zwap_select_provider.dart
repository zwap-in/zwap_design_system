part of zwap_select;

List<PhysicalKeyboardKey> _textKeys = [
  PhysicalKeyboardKey.keyA,
  PhysicalKeyboardKey.keyB,
  PhysicalKeyboardKey.keyC,
  PhysicalKeyboardKey.keyD,
  PhysicalKeyboardKey.keyE,
  PhysicalKeyboardKey.keyF,
  PhysicalKeyboardKey.keyG,
  PhysicalKeyboardKey.keyH,
  PhysicalKeyboardKey.keyI,
  PhysicalKeyboardKey.keyJ,
  PhysicalKeyboardKey.keyK,
  PhysicalKeyboardKey.keyL,
  PhysicalKeyboardKey.keyM,
  PhysicalKeyboardKey.keyN,
  PhysicalKeyboardKey.keyO,
  PhysicalKeyboardKey.keyP,
  PhysicalKeyboardKey.keyQ,
  PhysicalKeyboardKey.keyR,
  PhysicalKeyboardKey.keyS,
  PhysicalKeyboardKey.keyT,
  PhysicalKeyboardKey.keyU,
  PhysicalKeyboardKey.keyV,
  PhysicalKeyboardKey.keyW,
  PhysicalKeyboardKey.keyX,
  PhysicalKeyboardKey.keyY,
  PhysicalKeyboardKey.keyZ,
  PhysicalKeyboardKey.digit0,
  PhysicalKeyboardKey.digit1,
  PhysicalKeyboardKey.digit2,
  PhysicalKeyboardKey.digit3,
  PhysicalKeyboardKey.digit4,
  PhysicalKeyboardKey.digit5,
  PhysicalKeyboardKey.digit6,
  PhysicalKeyboardKey.digit7,
  PhysicalKeyboardKey.digit8,
  PhysicalKeyboardKey.digit0,
  PhysicalKeyboardKey.numpad0,
  PhysicalKeyboardKey.numpad1,
  PhysicalKeyboardKey.numpad2,
  PhysicalKeyboardKey.numpad3,
  PhysicalKeyboardKey.numpad4,
  PhysicalKeyboardKey.numpad5,
  PhysicalKeyboardKey.numpad6,
  PhysicalKeyboardKey.numpad7,
  PhysicalKeyboardKey.numpad8,
  PhysicalKeyboardKey.numpad9,
];

class _ZwapSelectProvider extends ChangeNotifier {
  late final TextEditingController _inputController;
  late final FocusNode _inputFocusNode;
  late final FocusNode _rawHanlderFocusNode;
  late final ScrollController _overlayScrollController;

  final Function() toggleOverlayCallback;
  final FutureOr Function() openMobileBottomSheet;

  final Widget Function(BuildContext, String, String, bool)? itemBuilder;

  final Function(String key, List<String>? allSelectedValues) changeValueCallback;

  final ZwapSelectSearchTypes searchType;
  final _ZwapSelectTypes selectType;

  final Duration? _betweenFetchDuration;
  final Duration? _onEmptyResponseDuration;
  final Duration? _searchDuration;

  //? -------------- Used in [zwap_select_mobile_bottom_sheed.dart] --------------
  final bool _canSearch;
  final bool _canAddItem;
  final Function(String) translateKey;
  final String? label;
  final String? placeholder;

  /// If true the text of the [_inputController] will not
  /// be used to show the selected item
  final bool _hasCustomBuilderForItems;

  bool _isOverlayOpen;

  /// If not null, is the timestamp until new data callback can
  /// be called (for when the [_inputController.text] is empty)
  int? _mainDataFetchBlockedUntil;

  /// If not null, is the timestamp until new data callback can
  /// be called (for when the [_inputController.text] is not empty)
  int? _tmpDataFetchBlockedUntil;

  List<MapEntry<String, String>> _selectedValues;

  /// Used to detect when notify some changes
  String _currentValue = '';

  /// Used to auto fetch data if required
  Timer? _searchTimer;

  /// Those values are used when the search text is empty
  Map<String, String> _values;

  /// Those values are used when the search text is not empty for the current search value
  Map<String, String> _tmpValues;

  /// If [true] the component is loading more data
  bool _isLoading;

  String? _currentHoveredKey;

  /// If not null and user scrolls to the end this function will be called and new items will be automatically added
  ///
  /// [pageNumber] is auto incremented only if the response is not empty.
  ///
  /// * Delays between [fetchMoreData] invocations are started after the response
  /// * Delays are cleared on text value changes
  ///
  /// See [betweenFetchDuration] and [onEmptyResponseDuration] to delay details
  final Future<Map<String, String>> Function(String inputValue, int pageNumber)? _fetchMoreDataCallback;

  final Function(String value)? onAddItem;

  int _mainPageNumber;
  int _tmpPageNumber = 1;

  double _overlayHeigth = 0;

  bool get _isSmall => getMultipleConditions(false, false, false, true, true);

  TextEditingController get inputController => _inputController;
  bool get isLoading => _isLoading;
  String? get currentHoveredKey => _currentHoveredKey;
  List<String> get selectedValues => _selectedValues.map((e) => e.key).toList();

  Map<String, String> get values {
    late Map<String, String> _tmp;
    if (searchType == ZwapSelectSearchTypes.locale) {
      _tmp = Map.fromEntries(_values.entries.where((e) => e.value.trim().toLowerCase().contains(_currentValue.toLowerCase())));
      for (MapEntry e in _selectedValues) if (!_tmp.keys.contains(e.key)) _tmp[e.key] = e.value;
    } else if (_currentValue.isEmpty || !_isOverlayOpen) {
      _tmp = _values;
      for (MapEntry e in _selectedValues) if (!_tmp.keys.contains(e.key)) _tmp[e.key] = e.value;
    } else
      _tmp = _tmpValues;

    return _tmp;
  }

  set isOverlayOpen(bool value) => _isOverlayOpen = value;
  set currentHoveredKey(String? value) {
    _currentHoveredKey = value;
    notifyListeners();
  }

  _ZwapSelectProvider({
    required Map<String, String> initialValues,
    required this.searchType,
    required this.selectType,
    required Duration betweenFetchDuration,
    required Duration onEmptyResponseDuration,
    Duration? searchDuration,
    required Future<Map<String, String>> Function(String inputValue, int pageNumber)? fetchMoreDataCallback,
    required this.toggleOverlayCallback,
    required this.openMobileBottomSheet,
    required this.changeValueCallback,
    required bool canSearch,
    required bool canAddItem,
    required this.label,
    required this.placeholder,
    required this.translateKey,
    required bool hasCustomBuilderForItems,
    this.onAddItem,
    int? initialPageNumber,
    List<String>? initialSelectedKey,
    this.itemBuilder,
  })  : this._isLoading = false,
        this._isOverlayOpen = false,
        this._hasCustomBuilderForItems = hasCustomBuilderForItems,
        this._values = initialValues,
        this._fetchMoreDataCallback = fetchMoreDataCallback,
        this._betweenFetchDuration = betweenFetchDuration,
        this._onEmptyResponseDuration = onEmptyResponseDuration,
        this._mainDataFetchBlockedUntil = null,
        this._tmpDataFetchBlockedUntil = null,
        this._currentValue = '',
        this._canSearch = canSearch,
        this._canAddItem = canAddItem,
        this._searchDuration = searchDuration,
        this._mainPageNumber = initialPageNumber ?? 1,
        this._tmpValues = const {},
        this._selectedValues = [] {
    _inputFocusNode = FocusNode(onKeyEvent: _inputFocusNodeHandler)..addListener(_inputFocusNodeListener);
    _rawHanlderFocusNode = FocusNode();
    _overlayScrollController = EdgeNotifierScrollController(
      delayDuration: Duration(milliseconds: 300),
      onEndReached: () => endReached(),
    );

    for (String key in initialSelectedKey ?? []) {
      _selectedValues.add(initialValues.entries.firstWhere((e) => e.key == key));
    }
    _inputController = TextEditingController(text: values[_selectedValues.firstOrNull?.key] ?? '')..addListener(_controllerListener);
  }

  void _inputFocusNodeListener() {
    if (_inputFocusNode.hasFocus && !_isOverlayOpen) {
      toggleOverlay();
    }
  }

  KeyEventResult _inputFocusNodeHandler(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent && [PhysicalKeyboardKey.tab, PhysicalKeyboardKey.enter, PhysicalKeyboardKey.escape].contains(event.physicalKey)) {
      if (event.physicalKey == PhysicalKeyboardKey.escape) {
        toggleOverlay();
        return KeyEventResult.handled;
      }

      toggleItem(_currentValue);
      return KeyEventResult.handled;
    }

    if (event is! KeyUpEvent || _isLoading) return KeyEventResult.ignored;

    if (event.physicalKey == PhysicalKeyboardKey.escape) {
      toggleOverlay();
      return KeyEventResult.handled;
    } else if ([PhysicalKeyboardKey.tab, PhysicalKeyboardKey.enter].contains(event.physicalKey)) {}
    if ([PhysicalKeyboardKey.arrowDown, PhysicalKeyboardKey.arrowUp].contains(event.physicalKey)) {
      _inputFocusNode.unfocus();
      _rawHanlderFocusNode.requestFocus();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  KeyEventResult keyboardHandler(KeyEvent event) {
    if (event is KeyDownEvent &&
        [PhysicalKeyboardKey.tab, PhysicalKeyboardKey.enter, PhysicalKeyboardKey.space, PhysicalKeyboardKey.escape].contains(event.physicalKey)) {
      if ([PhysicalKeyboardKey.tab, PhysicalKeyboardKey.escape].contains(event.physicalKey)) {
        toggleOverlay();
        return KeyEventResult.ignored;
      }

      if (_currentHoveredKey == null) {
        return KeyEventResult.handled;
      }

      toggleItem(_currentHoveredKey ?? '');
      return KeyEventResult.handled;
    }

    if (event is! KeyUpEvent && event is! KeyRepeatEvent) return KeyEventResult.ignored;

    if (event.physicalKey == PhysicalKeyboardKey.escape) {
      if (_isOverlayOpen) toggleOverlay();
      return KeyEventResult.handled;
    } else if ([PhysicalKeyboardKey.arrowDown, PhysicalKeyboardKey.arrowUp].contains(event.physicalKey)) {
      if (_currentHoveredKey == null) {
        _currentHoveredKey = values.keys.first;
      } else {
        final int _currentIndex = values.keys.toList().indexOf(_currentHoveredKey!);
        if (event.physicalKey == PhysicalKeyboardKey.arrowDown && _currentIndex == values.keys.length - 1 && _fetchMoreDataCallback != null) {
          _overlayScrollController.animateTo(
            _overlayScrollController.position.maxScrollExtent + 10,
            duration: const Duration(milliseconds: 300),
            curve: Curves.decelerate,
          );
          return KeyEventResult.handled;
        }

        final int _newIndex = (_currentIndex + (event.physicalKey == PhysicalKeyboardKey.arrowUp ? -1 : 1)) % values.length;
        _currentHoveredKey = values.keys.elementAt(_newIndex);

        if ((26 + 8.0) * max(0, _newIndex) < _overlayScrollController.offset) {
          final double _newOffset = max(0, (26 + 8.0) * _newIndex);
          _overlayScrollController.animateTo(_newOffset, duration: _searchDuration ?? const Duration(milliseconds: 300), curve: Curves.decelerate);
        } else if ((26 + 8.0) * max(0, _newIndex + 1) > _overlayScrollController.offset + _overlayHeigth) {
          final double _newOffset = (26 + 8.0) * (_newIndex + 1);
          _overlayScrollController.animateTo(min(_newOffset - _overlayHeigth, _overlayScrollController.position.maxScrollExtent - 2),
              duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
        }
      }
      notifyListeners();
      return KeyEventResult.handled;
    } else if (_textKeys.contains(event.physicalKey)) {
      _rawHanlderFocusNode.unfocus();
      _inputFocusNode.requestFocus();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _controllerListener() {
    if (!_isOverlayOpen) return;
    _searchTimer?.cancel();

    final String _tmp = _currentValue;
    _currentValue = inputController.text;

    final bool _notifyForLocalSearch = searchType == ZwapSelectSearchTypes.locale;
    final bool _notifyForDynamicSearch = searchType == ZwapSelectSearchTypes.dynamic && _tmp != _currentValue;

    if (_notifyForLocalSearch || _notifyForDynamicSearch) {
      _tmpValues = {};
      notifyListeners();
    }

    if (_notifyForDynamicSearch) _searchTimer = Timer(const Duration(milliseconds: 800), _searchCallback);
  }

  /// Perform a search, reset the tmp data and the tmp page number
  Future<void> _searchCallback() async {
    if (_isLoading) return;
    if (_currentValue.isEmpty || searchType == ZwapSelectSearchTypes.locale) return;

    _tmpValues = {};
    _isLoading = true;
    notifyListeners();

    _tmpValues = await _fetchMoreDataCallback!(_currentValue, _tmpPageNumber = 1);
    _isLoading = false;
    notifyListeners();
  }

  /// Should be called each time user scoll to the end, the delay are
  /// managed by the provider
  void endReached() async {
    if (_fetchMoreDataCallback == null) return;

    if (_isLoading) return;
    if (_currentValue.isEmpty && DateTime.now().millisecondsSinceEpoch < (_mainDataFetchBlockedUntil ?? -1)) return;
    if (_currentValue.isNotEmpty && DateTime.now().millisecondsSinceEpoch < (_tmpDataFetchBlockedUntil ?? -1)) return;

    _isLoading = true;
    notifyListeners();

    if (_currentValue.isEmpty) {
      Map<String, String> _newData = await _fetchMoreDataCallback!('', _mainPageNumber);

      if (_newData.isEmpty && _onEmptyResponseDuration != null)
        _mainDataFetchBlockedUntil = DateTime.now().millisecondsSinceEpoch + _onEmptyResponseDuration!.inMilliseconds;

      if (_newData.isNotEmpty && _betweenFetchDuration != null)
        _mainDataFetchBlockedUntil = DateTime.now().millisecondsSinceEpoch + _betweenFetchDuration!.inMilliseconds;

      if (_newData.isNotEmpty) {
        _mainPageNumber++;
        _values.addAll(_newData);
      }
    } else {
      Map<String, String> _newData = await _fetchMoreDataCallback!(_currentValue, _tmpPageNumber++);

      if (_newData.isEmpty && _onEmptyResponseDuration != null)
        _tmpDataFetchBlockedUntil = DateTime.now().millisecondsSinceEpoch + _onEmptyResponseDuration!.inMilliseconds;

      if (_newData.isNotEmpty && _betweenFetchDuration != null)
        _tmpDataFetchBlockedUntil = DateTime.now().millisecondsSinceEpoch + _betweenFetchDuration!.inMilliseconds;

      if (_newData.isNotEmpty) {
        _tmpPageNumber++;
        _tmpValues.addAll(_newData);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Valid only when the [searchType] == [ZwapSelectSearchTypes.locale]
  ///
  /// Used to change the values
  void originalValuesChanged(Map<String, String> newValues) {
    _values = newValues;
    notifyListeners();
  }

  void toggleItem(String? key, {bool callWidgetCallback = true}) {
    if (key == null) return;

    MapEntry? _selectedItem = _selectedValues.firstWhereOrNull((e) => e.key == key);

    if (_selectedItem != null) {
      _selectedValues.removeWhere((e) => e.key == key);
    } else {
      MapEntry<String, String>? _entry = values.entries.firstWhereOrNull((e) => e.key == key);
      if (_entry == null && onAddItem != null) {
        onAddItem!(key);
      }

      if (_entry == null && onAddItem == null) return;

      if (selectType == _ZwapSelectTypes.regular) {
        _selectedValues = [_entry ?? MapEntry(key, key)];

        //? This false/true will make [_controllerListener] callbaack not start a search
        bool _wasOvelrayOpen = _isOverlayOpen;

        _isOverlayOpen = false;
        if (!_hasCustomBuilderForItems) _inputController.text = values[key] ?? '';
        _isOverlayOpen = _wasOvelrayOpen;

        _currentHoveredKey = null;
        toggleOverlay();
      } else {
        _selectedValues.add(_entry ?? MapEntry(key, key));
      }
    }

    notifyListeners();
    if (callWidgetCallback) changeValueCallback(key, selectedValues);
  }

  /// If called, all selected values will be replaced with those values
  ///
  /// All values must be present int he current values
  void selectedChanged(List<String> keys) {
    _selectedValues = [];

    for (String key in keys) {
      _selectedValues.add(values.entries.firstWhere((e) => e.key == key));
    }
  }

  void toggleOverlay() {
    if (!_isSmall) _isOverlayOpen = !_isOverlayOpen;

    if (!_isOverlayOpen && selectType == _ZwapSelectTypes.regular) {
      if (!_hasCustomBuilderForItems) _inputController.text = values[selectedValues.firstOrNull] ?? selectedValues.firstOrNull ?? '';
    }

    if (!_isOverlayOpen && _inputFocusNode.hasFocus) _inputFocusNode.unfocus();
    if (_isOverlayOpen) {
      _inputController.text = '';
      if (!_inputFocusNode.hasFocus) {
        _inputFocusNode.requestFocus();
      }
    }

    if (!_isSmall) toggleOverlayCallback();
  }
}
