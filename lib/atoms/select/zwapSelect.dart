/// IMPORTING THIRD PARTY PACKAGES
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';
import 'package:zwap_utils/zwap_utils/type.dart';
import 'package:collection/collection.dart';

enum _ZwapSelectTypes { regular, multiple }

//FEATURE: Imrpove mobile UX with a fully customized layout

///This should be used only for interactions between ZwapSelect and its overlay
class _ZwapSelectProvider extends ChangeNotifier {
  Map<String, String> _originalValues;
  List<String> selectedValues;
  bool isLoading;
  String searchedValue;

  Map<String, String> _dynamicValues = {};

  Map<String, String> get allValues => {..._originalValues, ..._dynamicValues};

  _ZwapSelectProvider(this._originalValues)
      : this.isLoading = false,
        this.selectedValues = [],
        this.searchedValue = '';

  set searched(String value) => searchedValue != value ? {searchedValue = value, notifyListeners()} : null;

  void addNewValues(Map<String, String> newValues) {
    newValues.removeWhere((k, v) => _originalValues.keys.contains(k));
    _dynamicValues = {..._dynamicValues, ...newValues};
    notifyListeners();
  }

  void originalValuesChanged(Map<String, String> newValues) {
    _originalValues = newValues;
    notifyListeners();
  }

  void setLoading(bool newValue) {
    if (newValue != isLoading) {
      isLoading = newValue;
      notifyListeners();
    }
  }

  void selectedChanged(List<String> selected) {
    selectedValues = List.from(selected);
    notifyListeners();
  }
}

/// custom dropdown widget to select some element from a list
class ZwapSelect extends StatefulWidget {
  /// The custom values to display inside this widget
  ///
  /// { [key]: [value] }
  final Map<String, String> values;

  /// It handles the selected value with a callBack function
  ///
  /// If is regular select [allSelectedValues] is always null, and [key] is the current selected value
  ///
  /// If is multiple select the function will be called both on add and remove items:
  /// * [allSelectedValues] are new selected values,
  /// * [key] is the key of the element who was added or removed
  final Function(String key, List<String>? allSelectedValues) callBackFunction;

  /// Called only if [canAddItem] is true when user click add new item
  final Function(String newItem)? onAddItem;

  /// If [true] user can add new values
  final bool canAddItem;

  /// The current value of select input, if is regular select
  ///
  /// Ignored if multiple select
  final String? selected;

  /// The current selected item keys, if multiple select
  ///
  /// Always empty if is regular select
  ///
  /// Cannot be null, can be empty
  final List<String> selectedValues;

  /// Text to display if there is no selected value
  final String hintText;

  /// The [hintText] text style
  final TextStyle? hintTextStyle;

  /// If [true] user can type and filter items
  final bool canSearch;

  /// The select overlay mac height
  final double? maxOverlayHeight;

  /// If not null a label will be displayed with this value
  final String? label;

  /// If not null and user scrolls to the end this function will be called and new items will be automatically added
  ///
  /// [pageNumber] is auto incremented only if the response is not empty.
  ///
  /// * Delays between [fetchMoreData] invocations are started after the response
  /// * Delays are cleared on text value changes
  ///
  /// See [betweenFetchDuration] and [onEmptyResponseDuration] to delay details
  final Future<Map<String, String>> Function(String inputValue, int pageNumber)? fetchMoreData;

  /// The initial page number used for call fetchMoreData callback
  final int initialPageNumber;

  /// The custom values to display inside this widget, divided by category
  ///
  /// ! VALUES MUST HAVE DIFFERENT KEYS EVEN IN DIFFERENT CATEGORIES !
  ///
  /// ! If [canAddItem] is true make sure to manually add new items both in [selected]/[selectedValues] and [valuesByCategory]
  /// otherwise some unwonted thing can happen !
  ///
  /// { [category]: { [key]: [value] } }
  final Map<String, Map<String, String>> valuesByCategory;

  /// Used to wait a delay between the [fetchMoreData] callbacks
  final Duration betweenFetchDuration;

  /// Used to wait a delay between the [fetchMoreData] callbacks if one reply with empty responses
  final Duration onEmptyResponseDuration;

  final _ZwapSelectTypes _type;
  final bool _hasCategories;

  final double borderRadius;

  ///Regular ZwapSelect
  ZwapSelect({
    Key? key,
    required this.values,
    required this.callBackFunction,
    this.selected,
    this.hintText = '',
    this.canAddItem = false,
    this.onAddItem,
    this.canSearch = false,
    this.maxOverlayHeight,
    this.label,
    this.fetchMoreData,
    this.initialPageNumber = 1,
    this.betweenFetchDuration = const Duration(milliseconds: 800),
    this.onEmptyResponseDuration = const Duration(seconds: 10),
    this.hintTextStyle,
    this.borderRadius = 4,
  })  : this.selectedValues = [],
        this._type = _ZwapSelectTypes.regular,
        this.valuesByCategory = {},
        this._hasCategories = false,
        assert(values.isNotEmpty),
        super(key: key);

  ZwapSelect.withCategories({
    Key? key,
    required this.valuesByCategory,
    required this.callBackFunction,
    this.selected,
    this.hintText = '',
    this.canAddItem = false,
    this.onAddItem,
    this.canSearch = false,
    this.maxOverlayHeight,
    this.label,
    this.fetchMoreData,
    this.betweenFetchDuration = const Duration(milliseconds: 800),
    this.onEmptyResponseDuration = const Duration(seconds: 10),
    this.initialPageNumber = 1,
    this.hintTextStyle,
    this.borderRadius = 4,
  })  : this.selectedValues = [],
        this._type = _ZwapSelectTypes.regular,
        this.values = {
          for (String k in valuesByCategory.keys)
            for (String _k in valuesByCategory[k]?.keys ?? []) _k: valuesByCategory[k]![_k]!,
        },
        this._hasCategories = true,
        assert(valuesByCategory.isNotEmpty),
        super(key: key);

  ///Multiple ZwapSelect, multiple items will be displayed with ZwapTags
  ZwapSelect.multiple({
    Key? key,
    required this.values,
    required this.callBackFunction,
    this.betweenFetchDuration = const Duration(milliseconds: 800),
    this.onEmptyResponseDuration = const Duration(seconds: 10),
    this.selectedValues = const [],
    this.hintText = '',
    this.canAddItem = false,
    this.onAddItem,
    this.canSearch = false,
    this.maxOverlayHeight,
    this.label,
    this.fetchMoreData,
    this.initialPageNumber = 1,
    this.hintTextStyle,
    this.borderRadius = 4,
  })  : this.selected = null,
        this._type = _ZwapSelectTypes.multiple,
        this._hasCategories = false,
        this.valuesByCategory = {},
        assert(values.isNotEmpty),
        super(key: key);

  ZwapSelect.multipleWithCategories({
    Key? key,
    required this.valuesByCategory,
    required this.callBackFunction,
    this.selectedValues = const [],
    this.betweenFetchDuration = const Duration(milliseconds: 800),
    this.onEmptyResponseDuration = const Duration(seconds: 10),
    this.hintText = '',
    this.canAddItem = false,
    this.onAddItem,
    this.canSearch = false,
    this.maxOverlayHeight,
    this.label,
    this.fetchMoreData,
    this.initialPageNumber = 1,
    this.hintTextStyle,
    this.borderRadius = 4,
  })  : this.selected = null,
        this._type = _ZwapSelectTypes.multiple,
        this.values = {
          for (String k in valuesByCategory.keys)
            for (String _k in valuesByCategory[k]?.keys ?? []) _k: valuesByCategory[k]![_k]!,
        },
        this._hasCategories = true,
        assert(valuesByCategory.isNotEmpty),
        super(key: key);

  _ZwapSelectState createState() => _ZwapSelectState();

  bool get isRegular => _type == _ZwapSelectTypes.regular;
  bool get isMultiple => _type == _ZwapSelectTypes.multiple;
}

/// Description: the state for this current widget
class _ZwapSelectState extends State<ZwapSelect> {
  final GlobalKey _selectKey = GlobalKey();
  final ScrollController _overlayScrollController = ScrollController();

  late final _ZwapSelectProvider _provider;

  /// The keys of the current selected items
  List<String> _selectedValues = [];

  /// If [true] the select input is hovered
  bool _isHovered = false;

  /// The key of the current hovered item
  String? _hoveredItem;

  /// Object for select overlay control
  OverlayEntry? _selectOverlay;

  /// Text input
  late final TextEditingController _inputController;
  late final FocusNode _inputFocus;

  /// The progressive number for requesting page
  late int _pageNumber;

  List<String> get categories => widget.valuesByCategory.keys.toList();

  Timer? _updateCanSearchTimer;
  bool _canSearch = true;

  @override
  void initState() {
    super.initState();

    _selectedValues = widget.isMultiple ? widget.selectedValues : [if (widget.selected != null) widget.selected!];

    _pageNumber = widget.initialPageNumber;

    _inputController = TextEditingController(text: widget.selected);
    _inputFocus = FocusNode(onKey: (node, event) {
      if (event.physicalKey == PhysicalKeyboardKey.escape && (_selectOverlay?.mounted ?? false)) {
        if (widget.isRegular) _inputController.text = _provider.allValues[_selectedValues.firstOrNull ?? ''] ?? '';

        if (_inputFocus.hasFocus) _inputFocus.unfocus();
        return KeyEventResult.skipRemainingHandlers;
      }

      if (event.physicalKey == PhysicalKeyboardKey.end || event.physicalKey == PhysicalKeyboardKey.tab) {
        _continueKeyPressed();
        return KeyEventResult.handled;
      }

      if (!widget.canSearch) return KeyEventResult.handled;
      return KeyEventResult.ignored;
    });

    _inputController.addListener(_controllerListener);
    _inputFocus.addListener(_focusListener);
    _overlayScrollController.addListener(_scrollControllerListener);

    _provider = _ZwapSelectProvider(widget.values);
    _provider.selectedChanged(_selectedValues);
  }

  void _focusListener() {
    final bool _isOpened = _selectOverlay?.mounted ?? false;

    if ((_isOpened && !_inputFocus.hasFocus) || (!_isOpened && _inputFocus.hasFocus)) {
      _toggleOverlay();

      if (!_isOpened) {
        _inputController.text = '';
        _inputController.selection = TextSelection.collapsed(offset: 0);
      }
    }
  }

  void _controllerListener() {
    _provider.searched = _inputController.text;
    _updateCanSearchTimer?.cancel();
    _requestData(forcePageToOne: true);
  }

  void _scrollControllerListener() async {
    final bool _isAtEnd = _overlayScrollController.position.atEdge &&
        _overlayScrollController.position.pixels != 0 &&
        !_provider.isLoading &&
        !_overlayScrollController.position.outOfRange;

    if (_isAtEnd && _canSearch) {
      _canSearch = false;
      _updateCanSearchTimer?.cancel();
      _requestData(forcePageToOne: _inputController.text.isNotEmpty);
    }
  }

  _requestData({bool forcePageToOne = false}) async {
    if (widget.fetchMoreData == null) return;

    _provider.setLoading(true);

    Map<String, String> tmp = await widget.fetchMoreData!(forcePageToOne ? _inputController.text : '', forcePageToOne ? 1 : _pageNumber);

    _updateCanSearchTimer = Timer(tmp.isEmpty ? widget.onEmptyResponseDuration : widget.betweenFetchDuration, () => _canSearch = true);

    if (!forcePageToOne && tmp.isNotEmpty) _pageNumber += 1;

    _provider.addNewValues(tmp);
    _provider.setLoading(false);
  }

  /// Called when text field is submitted with a physical key (such as: end, enter and tab keys)
  ///
  /// ! Called even when overlay auto close
  void _continueKeyPressed() {
    _inputFocus.unfocus();

    if (_inputController.text.trim().isNotEmpty &&
        !widget.values.containsKey(_inputController.text.trim()) &&
        widget.canAddItem &&
        widget.onAddItem != null) widget.onAddItem!(_inputController.text.trim());

    if (widget.isRegular) _inputController.text = _provider.allValues[_selectedValues.firstOrNull ?? ''] ?? '';
  }

  @override
  void didUpdateWidget(covariant ZwapSelect oldWidget) {
    if (!mapEquals(oldWidget.values, widget.values))
      WidgetsBinding.instance?.addPostFrameCallback((_) => _provider.originalValuesChanged(widget.values));
    if (widget.isRegular && widget.selected != oldWidget.selected)
      WidgetsBinding.instance?.addPostFrameCallback((_) => onChangeValue(widget.selected, callCallback: false));
    if (widget.isMultiple && !listEquals(widget.selectedValues, oldWidget.selectedValues))
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        setState(() => _selectedValues = widget.selectedValues);
        _provider.selectedChanged(widget.selectedValues);
      });

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _inputController.removeListener(_controllerListener);
    _inputFocus.removeListener(_focusListener);
    _overlayScrollController.removeListener(_scrollControllerListener);
    super.dispose();
  }

  /// Selecting new value from the dropdown widget
  void onChangeValue(String? value, {bool callCallback = true}) {
    if (value == null) return;

    if (widget.isMultiple) {
      if (_selectedValues.contains(value))
        _selectedValues.remove(value);
      else
        _selectedValues.add(value);
    } else {
      _selectedValues = [value];
      _inputController.text = _provider.allValues[value] ?? '';
    }

    _provider.selectedChanged(_selectedValues);

    if (callCallback) widget.callBackFunction(value, _selectedValues);

    if (_inputFocus.hasFocus && widget.isRegular) _inputFocus.unfocus();

    setState(() {});
  }

  void _toggleOverlay() {
    if (_selectOverlay?.mounted ?? false) {
      try {
        _selectOverlay!.remove();
      } catch (e) {}
      _selectOverlay = null;
    } else {
      Overlay.of(context)?.insert(_selectOverlay = _createOverlay());
      if (!_inputFocus.hasFocus) _inputFocus.requestFocus();
      Future.delayed(const Duration(milliseconds: 200), () => _provider.selectedChanged(_selectedValues));
    }

    setState(() {});
  }

  bool get openReverse => (_selectKey.globalOffset?.dy ?? 0) + 45 + 150 >= MediaQuery.of(context).size.height - 50;

  OverlayEntry _createOverlay() {
    final double _top = (_selectKey.globalOffset?.dy ?? 0) + 45;
    final double _bottom = MediaQuery.of(context).size.height - _top + 45;

    double _maxHeight = widget.maxOverlayHeight ?? MediaQuery.of(context).size.height * 0.3;

    //? If reverse open is true, overlay will be show above inpu
    bool _reverseOpen = false;

    if (_top + _maxHeight >= MediaQuery.of(context).size.height - 50) {
      if (openReverse)
        _reverseOpen = true;
      else
        _maxHeight = MediaQuery.of(context).size.height - 50 - _top;
    }

    return OverlayEntry(
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: _provider,
          child: Builder(
            builder: (context) {
              bool _isLoading = context.select<_ZwapSelectProvider, bool>((pro) => pro.isLoading);
              Map<String, String> _allValues = context.select<_ZwapSelectProvider, Map<String, String>>((pro) => pro.allValues);
              String _searchedValue = context.select<_ZwapSelectProvider, String>((pro) => pro.searchedValue);
              List<String> _selectedValues = context.select<_ZwapSelectProvider, List<String>>((pro) => pro.selectedValues);

              Map<String, String> _toShowValues = Map.from(_allValues)
                ..removeWhere((k, v) => v.isNotEmpty && !v.toLowerCase().trim().contains(_searchedValue.toLowerCase().trim()));

              return ZwapOverlayEntryWidget(
                entity: _selectOverlay,
                onAutoClose: () => _continueKeyPressed(),
                child: ZwapOverlayEntryChild(
                  top: _reverseOpen ? null : _top,
                  bottom: _reverseOpen ? _bottom : null,
                  left: _selectKey.globalOffset?.dx ?? 0,
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.decelerate,
                    tween: Tween(begin: 0, end: 1),
                    builder: (context, animation, child) => Opacity(
                      opacity: animation,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ZwapColors.neutral300,
                          borderRadius: openReverse
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(widget.borderRadius),
                                  topRight: Radius.circular(widget.borderRadius),
                                )
                              : BorderRadius.only(
                                  bottomLeft: Radius.circular(widget.borderRadius),
                                  bottomRight: Radius.circular(widget.borderRadius),
                                ),
                        ),
                        child: Container(
                          width: (_selectKey.globalPaintBounds?.size.width ?? 2) - 2,
                          decoration: BoxDecoration(
                            color: ZwapColors.shades0,
                            borderRadius: openReverse
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(widget.borderRadius),
                                    topRight: Radius.circular(widget.borderRadius),
                                  )
                                : BorderRadius.only(
                                    bottomLeft: Radius.circular(widget.borderRadius),
                                    bottomRight: Radius.circular(widget.borderRadius),
                                  ),
                          ),
                          margin:
                              openReverse ? const EdgeInsets.only(top: 1, left: 1, right: 1) : const EdgeInsets.only(bottom: 1, left: 1, right: 1),
                          constraints: BoxConstraints(maxHeight: _maxHeight),
                          child: SingleChildScrollView(
                            controller: _overlayScrollController,
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _toShowValues.isEmpty
                                  ? ([
                                      if (widget.canAddItem)
                                        Container(
                                          color: Colors.transparent,
                                          width: double.infinity,
                                          child: Material(
                                            color: '_random_key_for_this_item_2341234112341252456375' == _hoveredItem
                                                ? ZwapColors.neutral100
                                                : ZwapColors.shades0,
                                            borderRadius: BorderRadius.circular(8),
                                            child: InkWell(
                                              onTap: () {
                                                if (widget.onAddItem == null) return;
                                                final String _newItemValue = _inputController.text;
                                                _inputController.text = '';

                                                widget.onAddItem!(_newItemValue);

                                                if (widget.isRegular) return;

                                                _provider.addNewValues({_newItemValue: _newItemValue});
                                                setState(() {
                                                  _selectedValues.add(_newItemValue);
                                                  _provider.selectedChanged(_selectedValues);
                                                });
                                              },
                                              hoverColor: ZwapColors.neutral100,
                                              onHover: (hovered) =>
                                                  setState(() => _hoveredItem = hovered ? '_random_key_for_this_item_2341234112341252456375' : null),
                                              borderRadius: BorderRadius.circular(8),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                                                child: Row(
                                                  children: [
                                                    //TODO: traduci
                                                    ZwapRichText(
                                                      texts: {
                                                        '${_inputController.text}':
                                                            TupleType(a: null, b: TupleType(a: ZwapTextType.bodySemiBold, b: ZwapColors.shades100)),
                                                        ' not here? ':
                                                            TupleType(a: null, b: TupleType(a: ZwapTextType.bodyRegular, b: ZwapColors.shades100)),
                                                        'Add it here':
                                                            TupleType(a: null, b: TupleType(a: ZwapTextType.bodySemiBold, b: ZwapColors.shades100)),
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        Material(
                                          child: ZwapText(
                                            text: "No results",
                                            zwapTextType: ZwapTextType.bodyRegular,
                                            textColor: ZwapColors.shades100,
                                          ),
                                        ),
                                    ])
                                  : [
                                      widget._hasCategories
                                          ? _ZwapOverlayChildrenList.withCategories(
                                              hoveredItem: _hoveredItem,
                                              onHoverItem: (key, isHovered) => setState(() => _hoveredItem = isHovered ? key : null),
                                              onItemTap: (key) => onChangeValue(key),
                                              selectedValues: _selectedValues,
                                              valuesByCategory: _getToShowValuesByCategory(_toShowValues),
                                              reverse: _reverseOpen,
                                            )
                                          : _ZwapOverlayChildrenList(
                                              hoveredItem: _hoveredItem,
                                              onHoverItem: (key, isHovered) => setState(() => _hoveredItem = isHovered ? key : null),
                                              onItemTap: (key) => onChangeValue(key),
                                              selectedValues: _selectedValues,
                                              values: _toShowValues,
                                              reverse: _reverseOpen,
                                            ),
                                      if (_isLoading)
                                        Center(
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation(ZwapColors.primary800),
                                              strokeWidth: 0.5,
                                            ),
                                          ),
                                        )
                                    ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Map<String, Map<String, String>> _getToShowValuesByCategory(Map<String, String> toShowValues) {
    final Map<String, Map<String, String>> res = {};

    String? getCategoryOf(String key) {
      for (String cat in widget.valuesByCategory.keys) if (widget.valuesByCategory[cat]!.containsKey(key)) return cat;
      return null;
    }

    for (String k in toShowValues.keys) {
      String? _tmpCat = getCategoryOf(k);
      if (_tmpCat == null) continue;

      if (res.containsKey(_tmpCat))
        res[_tmpCat]![k] = toShowValues[k]!;
      else
        res[_tmpCat] = {k: toShowValues[k]!};
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    final bool _showTags = !_inputFocus.hasFocus && widget.isMultiple && _selectedValues.isNotEmpty;

    return ChangeNotifierProvider.value(
      value: _provider,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            ZwapText(
              text: widget.label!,
              zwapTextType: ZwapTextType.bodySemiBold,
              textColor: ZwapColors.neutral600,
            ),
            SizedBox(height: 5),
          ],
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onHover: (bool value) => setState(() => _isHovered = value),
            onTap: () {
              if (!_inputFocus.hasFocus) _inputFocus.requestFocus();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: (_selectOverlay?.mounted ?? false)
                  ? openReverse
                      ? BoxDecoration(
                          color: ZwapColors.neutral300,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(widget.borderRadius),
                            bottomRight: Radius.circular(widget.borderRadius),
                          ),
                        )
                      : BoxDecoration(
                          color: ZwapColors.neutral300,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(widget.borderRadius),
                            topRight: Radius.circular(widget.borderRadius),
                          ),
                        )
                  : BoxDecoration(
                      color: this._isHovered ? ZwapColors.primary300 : ZwapColors.neutral300,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
              child: Container(
                key: _selectKey,
                height: 45,
                decoration: BoxDecoration(
                  color: ZwapColors.shades0,
                  borderRadius: (_selectOverlay?.mounted ?? false)
                      ? openReverse
                          ? BorderRadius.only(
                              bottomLeft: Radius.circular(widget.borderRadius),
                              bottomRight: Radius.circular(widget.borderRadius),
                            )
                          : BorderRadius.only(
                              topLeft: Radius.circular(widget.borderRadius),
                              topRight: Radius.circular(widget.borderRadius),
                            )
                      : BorderRadius.circular(widget.borderRadius),
                ),
                margin: _selectOverlay?.mounted ?? false
                    ? openReverse
                        ? const EdgeInsets.only(bottom: 1, left: 1, right: 1)
                        : const EdgeInsets.only(top: 1, left: 1, right: 1)
                    : const EdgeInsets.all(1),
                padding: const EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: _showTags ? 0 : 1,
                              child: IgnorePointer(
                                ignoring: _showTags,
                                child: Center(
                                  child: TextField(
                                    controller: _inputController,
                                    focusNode: _inputFocus,
                                    decoration: InputDecoration.collapsed(hintText: widget.hintText, hintStyle: widget.hintTextStyle),
                                    cursorColor: widget.canSearch ? ZwapColors.shades100 : ZwapColors.shades0,
                                    keyboardType: TextInputType.none,
                                    onSubmitted: (_) => _continueKeyPressed(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: _showTags ? 1 : 0,
                              child: IgnorePointer(
                                ignoring: !_showTags,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: _selectedValues
                                        .map((k) => Container(
                                              margin: const EdgeInsets.only(left: 4),
                                              child: _ZwapTag(
                                                tagValue: _provider.allValues[k] ?? '',
                                                tagKey: k,
                                                onCancel: (k) => onChangeValue(k),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    AnimatedRotation(
                      turns: (_selectOverlay?.mounted ?? false) ? 0 : 0.5,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(Icons.keyboard_arrow_up, color: Color.fromRGBO(50, 50, 50, 1), key: ValueKey(_selectOverlay?.mounted)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZwapTag extends StatelessWidget {
  final String tagKey;
  final String tagValue;
  final Function(String tagKey)? onCancel;

  const _ZwapTag({required this.tagKey, required this.tagValue, this.onCancel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ZwapColors.primary700, borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ZwapText(
              text: tagValue,
              zwapTextType: ZwapTextType.bodyRegular,
              textColor: ZwapColors.shades0,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 7),
          GestureDetector(
            onTap: () => onCancel != null ? onCancel!(tagKey) : null,
            child: Center(child: ZwapIcons.icons('close', iconColor: ZwapColors.shades0, iconSize: 15)),
          ),
        ],
      ),
    );
  }
}

class _ZwapOverlayChildrenList extends StatelessWidget {
  final bool reverse;

  final Map<String, String> values;
  final Map<String, Map<String, String>> valuesByCategory;

  final List<String> selectedValues;
  final String? hoveredItem;

  final Function(String key) onItemTap;
  final Function(String key, bool isHovered) onHoverItem;

  final bool _hasCategories;

  const _ZwapOverlayChildrenList({
    required this.values,
    required this.selectedValues,
    required this.hoveredItem,
    required this.onHoverItem,
    required this.onItemTap,
    this.reverse = false,
    Key? key,
  })  : this.valuesByCategory = const {},
        this._hasCategories = false,
        super(key: key);

  const _ZwapOverlayChildrenList.withCategories({
    required this.valuesByCategory,
    required this.selectedValues,
    required this.hoveredItem,
    required this.onHoverItem,
    required this.onItemTap,
    this.reverse = false,
    Key? key,
  })  : this.values = const {},
        this._hasCategories = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, String> _allValues = context.select<_ZwapSelectProvider, Map<String, String>>((pro) => pro.allValues);

    Widget _singleElementWidget(bool isLast, String k, {bool indent = false}) {
      return Container(
        color: Colors.transparent,
        width: double.infinity,
        margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
        child: Material(
          color: selectedValues.contains(k)
              ? k == hoveredItem
                  ? ZwapColors.primary50
                  : ZwapColors.primary100
              : k == hoveredItem
                  ? ZwapColors.neutral100
                  : ZwapColors.shades0,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () => this.onItemTap(k),
            hoverColor: selectedValues.contains(k) ? ZwapColors.primary50 : ZwapColors.neutral100,
            splashColor: selectedValues.contains(k) ? Colors.transparent : null,
            onHover: (hovered) => onHoverItem(k, hovered),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: indent ? const EdgeInsets.only(top: 3, bottom: 3, left: 17, right: 7) : const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
              child: Row(
                children: [
                  Expanded(
                    child: ZwapText(
                      text: _allValues[k] ?? '<error>',
                      zwapTextType: ZwapTextType.bodyRegular,
                      textColor: selectedValues.contains(k) ? ZwapColors.primary800 : ZwapColors.shades100,
                    ),
                  ),
                  if (selectedValues.contains(k)) ...[
                    SizedBox(width: 5),
                    Icon(Icons.check, color: ZwapColors.shades100, size: 20),
                  ]
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (_hasCategories) {
      return Column(
        children: valuesByCategory.keys
            .toList()
            .mapIndexed((catI, cat) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                      child: Material(
                        child: ZwapText(
                          text: cat,
                          zwapTextType: ZwapTextType.bodySemiBold,
                          textColor: ZwapColors.shades100,
                        ),
                      ),
                    ),
                    Column(
                      children: valuesByCategory[cat]!
                          .keys
                          .toList()
                          .mapIndexed((i, key) => _singleElementWidget(
                              catI + 1 == valuesByCategory.keys.length && i + 1 == valuesByCategory[cat]!.keys.length, key,
                              indent: true))
                          .toList(),
                    ),
                  ],
                ))
            .toList(),
      );
    }

    return Column(
      children: values.keys.toList().mapIndexed((i, key) => _singleElementWidget(i == values.keys.toList().length, key)).toList(),
    );
  }
}
