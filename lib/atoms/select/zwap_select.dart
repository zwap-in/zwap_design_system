library zwap_select;

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taastrap/taastrap.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

import 'package:zwap_design_system/extensions/globalKeyExtension.dart';
import 'package:zwap_design_system/utils/edge_notifier_scroll_controller.dart';
import 'package:collection/collection.dart';

part 'zwap_select_provider.dart';
part 'zwap_select_mobile_bottom_sheet.dart';

//TODO: Refactoring of the structure

typedef Widget ItemBuilder(BuildContext context, String key, String value, bool isHeader);

enum _ZwapSelectTypes { regular, multiple }

/// Type of searches supported by ZwapSelect:
/// * locale: widget will filter the keys using the test inserted by the user
/// * dynamic: widget will call the [fetchMoreData] method and show only those data
enum ZwapSelectSearchTypes {
  /// widget will filter the keys using the test inserted by the user
  locale,

  /// widget will call the [fetchMoreData] method and show only those data
  dynamic,
}

//FEATURE: Imrpove mobile UX with a fully customized layout

/// custom dropdown widget to select some element from a list
class ZwapSelect extends StatefulWidget {
  /// The custom values to display inside this widget
  ///
  /// ! **WARNING**: If [fetchMoreData] is provided any change to this field is ignored
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

  /// If provided, the same duration is waited before the search
  /// callback is called
  ///
  /// Default to 800 ms
  final Duration? searchDelayDuration;

  final _ZwapSelectTypes _type;
  final bool _hasCategories;

  final double borderRadius;

  final ZwapSelectSearchTypes searchType;

  /// Should return the translated text in base of the current locale
  ///
  /// Used keys:
  /// * "not_here": "not here?"
  /// * "add_here": "Add it here"
  final String Function(String key) translateText;

  /// If provided this function will be called:
  /// 1. for each element when the select overlay is showed
  /// 2. for the selected element when the overlay is closed
  ///
  /// If the select is multiple the 2nd point will be:<br>
  /// 2. for ach tag when the overlay is closed
  ///
  /// ### Function structure
  /// [itemBuilder] function will provide:
  /// * context: the current [BuildContext]
  /// * key and value: key and value of the current item (provided inside [values])
  /// * isHeader:
  ///   * is true if the widget is used to render the selected item (when select
  /// is single) or the widget inside the tag (when select is multiple)
  ///   * is false if the widget is used inside the ovelay
  final ItemBuilder? itemBuilder;

  final String? dynamicLabel;

  /// If true the error stete decorations will be used
  ///
  /// If [errorText] is provided, it will be showed, see
  /// [errorText] for more details
  ///
  /// Default to false
  final bool error;

  /// If provided this string will be showed under the
  /// select widget when [error] is true
  final String? errorText;

  ///Regular ZwapSelect
  ZwapSelect({
    Key? key,
    required this.values,
    required this.callBackFunction,
    required this.translateText,
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
    this.borderRadius = 8,
    this.searchType = ZwapSelectSearchTypes.dynamic,
    this.searchDelayDuration,
    this.itemBuilder,
    this.dynamicLabel,
    this.error = false,
    this.errorText,
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
    required this.translateText,
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
    this.borderRadius = 8,
    this.searchDelayDuration,
    this.searchType = ZwapSelectSearchTypes.dynamic,
    this.itemBuilder,
    this.dynamicLabel,
    this.error = false,
    this.errorText,
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
    required this.translateText,
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
    this.borderRadius = 8,
    this.searchType = ZwapSelectSearchTypes.dynamic,
    this.searchDelayDuration,
    this.itemBuilder,
    this.error = false,
    this.errorText,
  })  : this.selected = null,
        this._type = _ZwapSelectTypes.multiple,
        this._hasCategories = false,
        this.valuesByCategory = {},
        this.dynamicLabel = null,
        assert(values.isNotEmpty),
        super(key: key);

  ZwapSelect.multipleWithCategories({
    Key? key,
    required this.valuesByCategory,
    required this.callBackFunction,
    required this.translateText,
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
    this.borderRadius = 8,
    this.searchType = ZwapSelectSearchTypes.dynamic,
    this.searchDelayDuration,
    this.error = false,
    this.errorText,
  })  : this.selected = null,
        this._type = _ZwapSelectTypes.multiple,
        this.values = {
          for (String k in valuesByCategory.keys)
            for (String _k in valuesByCategory[k]?.keys ?? []) _k: valuesByCategory[k]![_k]!,
        },
        this._hasCategories = true,
        this.itemBuilder = null,
        this.dynamicLabel = null,
        assert(valuesByCategory.isNotEmpty),
        super(key: key);

  _ZwapSelectState createState() => _ZwapSelectState();

  bool get isRegular => _type == _ZwapSelectTypes.regular;
  bool get isMultiple => _type == _ZwapSelectTypes.multiple;
}

/// Description: the state for this current widget
class _ZwapSelectState extends State<ZwapSelect> {
  final GlobalKey _selectKey = GlobalKey();
  late final _ZwapSelectProvider _provider;

  /// If [true] the select input is hovered
  bool _isHovered = false;

  /// Object for select overlay control
  OverlayEntry? _selectOverlay;

  List<String> get categories => widget.valuesByCategory.keys.toList();

  late bool _error;

  @override
  void initState() {
    super.initState();

    _error = widget.error;

    final List<String> _selectedValues = widget.isMultiple ? widget.selectedValues : [if (widget.selected != null) widget.selected!];
    _provider = _ZwapSelectProvider(
      fetchMoreDataCallback: widget.fetchMoreData,
      initialValues: widget.values,
      toggleOverlayCallback: _toggleOverlay,
      openMobileBottomSheet: _showMobileBottomSheetWrap,
      betweenFetchDuration: widget.betweenFetchDuration,
      onEmptyResponseDuration: widget.onEmptyResponseDuration,
      searchType: widget.searchType,
      selectType: widget._type,
      initialPageNumber: widget.initialPageNumber,
      initialSelectedKey: _selectedValues,
      onAddItem: widget.onAddItem,
      canAddItem: widget.canAddItem,
      canSearch: widget.canSearch,
      translateKey: widget.translateText,
      changeValueCallback: widget.callBackFunction,
      label: widget.label,
      placeholder: widget.hintText,
      searchDuration: widget.searchDelayDuration,
      hasCustomBuilderForItems: widget.itemBuilder != null,
      itemBuilder: widget.itemBuilder,
    );
  }

  @override
  void didUpdateWidget(covariant ZwapSelect oldWidget) {
    if (widget.fetchMoreData == null && !mapEquals(oldWidget.values, widget.values)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _provider.originalValuesChanged(widget.values));
    }
    if (widget.isRegular && widget.selected != oldWidget.selected)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_provider.selectedValues.contains(widget.selected)) {
          _provider.toggleItem(widget.selected, callWidgetCallback: false);
        }
      });
    if (widget.isMultiple && !listEquals(widget.selectedValues, oldWidget.selectedValues))
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _provider.selectedChanged(widget.selectedValues);
      });
    if (widget.error != _error) setState(() => _error = widget.error);

    super.didUpdateWidget(oldWidget);
  }

  /// This method wrap _showMobileBottomSheet(...) method
  Future<void> _showMobileBottomSheetWrap() async {
    return _showMobileBottomSheet(context, _provider);
  }

  void _toggleOverlay() {
    if (isOverlayMounted) {
      try {
        _selectOverlay!.remove();
      } catch (e) {}
      _selectOverlay = null;
    } else {
      Overlay.of(context).insert(_selectOverlay = _createOverlay());
      // if (!_inputFocus.hasFocus) _inputFocus.requestFocus();
    }

    setState(() {});
  }

  bool get openReverse => (_selectKey.globalOffset?.dy ?? 0) + 45 + 150 >= MediaQuery.of(context).size.height - 50;
  bool get isOverlayMounted => _selectOverlay?.mounted ?? false;

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

    _provider._overlayHeigth = _maxHeight;

    return OverlayEntry(
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: _provider,
          child: Builder(
            builder: (context) {
              bool _isLoading = context.select<_ZwapSelectProvider, bool>((pro) => pro.isLoading);
              Map<String, String> _allValues = context.select<_ZwapSelectProvider, Map<String, String>>((pro) => pro.values);
              List<String> _selectedValues = context.select<_ZwapSelectProvider, List<String>>((pro) => pro.selectedValues);
              String? _hoveredItemKey = context.select<_ZwapSelectProvider, String?>((pro) => pro.currentHoveredKey);

              return ZwapOverlayEntryWidget(
                entity: _selectOverlay,
                onAutoClose: () {
                  _provider.toggleOverlay();
                  _selectOverlay = null;
                },
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
                      child: KeyboardListener(
                        focusNode: _provider._rawHanlderFocusNode,
                        onKeyEvent: _provider.keyboardHandler,
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
                              controller: _provider._overlayScrollController,
                              padding: const EdgeInsets.only(top: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _allValues.isEmpty
                                    ? _isLoading
                                        ? [
                                            Container(
                                              height: 2,
                                              padding: EdgeInsets.symmetric(horizontal: widget.borderRadius / 3),
                                              child: _isLoading
                                                  ? LinearProgressIndicator(
                                                      valueColor: AlwaysStoppedAnimation(ZwapColors.primary800),
                                                      minHeight: 2,
                                                    )
                                                  : null,
                                            )
                                          ]
                                        : ([
                                            if (widget.canAddItem)
                                              Container(
                                                padding: const EdgeInsets.only(left: 10, right: 10),
                                                color: Colors.transparent,
                                                width: double.infinity,
                                                child: Material(
                                                  color: '_random_key_for_this_item_2341234112341252456375' == _hoveredItemKey
                                                      ? ZwapColors.neutral100
                                                      : ZwapColors.shades0,
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: InkWell(
                                                    onTap: () => _simulateEnter(),
                                                    hoverColor: ZwapColors.neutral100,
                                                    onHover: (hovered) => _provider.currentHoveredKey =
                                                        hovered ? '_random_key_for_this_item_2341234112341252456375' : null,
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
                                                          ZwapRichText.safeText(
                                                            textSpans: [
                                                              ZwapTextSpan.fromZwapTypography(
                                                                text: '${_provider._inputController.text}',
                                                                textType: ZwapTextType.bodySemiBold,
                                                                textColor: ZwapColors.shades100,
                                                              ),
                                                              ZwapTextSpan.fromZwapTypography(
                                                                text: ' ${widget.translateText('not_here')} ',
                                                                textType: ZwapTextType.bodyRegular,
                                                                textColor: ZwapColors.shades100,
                                                              ),
                                                              ZwapTextSpan.fromZwapTypography(
                                                                text: widget.translateText('add_here'),
                                                                textType: ZwapTextType.bodySemiBold,
                                                                textColor: ZwapColors.shades100,
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            else
                                              Material(
                                                child: Container(
                                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                                  child: ZwapText(
                                                    text: "No results",
                                                    zwapTextType: ZwapTextType.bodyRegular,
                                                    textColor: ZwapColors.shades100,
                                                  ),
                                                ),
                                              ),
                                            SizedBox(height: 13),
                                          ])
                                    : [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, right: 10),
                                          child: widget._hasCategories
                                              ? _ZwapOverlayChildrenList.withCategories(
                                                  hoveredItem: _hoveredItemKey,
                                                  onHoverItem: (key, isHovered) => setState(() => _hoveredItemKey = isHovered ? key : null),
                                                  onItemTap: (key) => _provider.toggleItem(key),
                                                  selectedValues: _selectedValues,
                                                  valuesByCategory: _getToShowValuesByCategory(_allValues),
                                                  reverse: _reverseOpen,
                                                )
                                              : _ZwapOverlayChildrenList(
                                                  hoveredItem: _hoveredItemKey,
                                                  onHoverItem: (key, isHovered) => setState(() => _hoveredItemKey = isHovered ? key : null),
                                                  onItemTap: (key) => _provider.toggleItem(key),
                                                  selectedValues: _selectedValues,
                                                  values: _allValues,
                                                  reverse: _reverseOpen,
                                                ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: widget.borderRadius / 3),
                                          height: 2,
                                          child: _isLoading
                                              ? LinearProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation(ZwapColors.primary800),
                                                  minHeight: 2,
                                                )
                                              : null,
                                        )
                                      ],
                              ),
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

  void _simulateEnter() {
    _provider._inputFocusNodeHandler(
      _provider._inputFocusNode,
      KeyDownEvent(
        physicalKey: PhysicalKeyboardKey.enter,
        logicalKey: LogicalKeyboardKey.enter,
        timeStamp: Duration(
          milliseconds: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Builder(builder: (context) {
        final List<String> _selectedValues = context.select<_ZwapSelectProvider, List<String>>((state) => state.selectedValues);

        final bool _showTags = !_provider._inputFocusNode.hasFocus && widget.isMultiple && _selectedValues.isNotEmpty;
        final bool _showHeader = widget.itemBuilder != null &&
            widget._type == _ZwapSelectTypes.regular &&
            _provider._selectedValues.isNotEmpty &&
            (!widget.canSearch || !_provider._inputFocusNode.hasFocus);

        return Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: _provider._isSmall
                      ? () => _showMobileBottomSheet(context, _provider)
                      : !widget._hasCategories
                          ? () => _toggleOverlay()
                          : null,
                  behavior: _provider._isSmall ? HitTestBehavior.opaque : HitTestBehavior.translucent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.label != null) SizedBox(height: 9),
                      Semantics.fromProperties(
                        properties: SemanticsProperties(
                          label: widget.label == null ? null : "${widget.label}",
                          value: widget.isRegular ? _selectedValues.firstOrNull?.toString() : _selectedValues.toString(),
                        ),
                        child: InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onHover: (bool value) => setState(() => _isHovered = value),
                          onTap: () {
                            if (_provider._isSmall)
                              _showMobileBottomSheetWrap();
                            else
                              _provider.toggleOverlay();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.decelerate,
                            decoration: isOverlayMounted
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
                                    color: _error
                                        ? ZwapColors.error400
                                        : this._isHovered
                                            ? ZwapColors.primary300
                                            : ZwapColors.neutral300,
                                    borderRadius: BorderRadius.circular(widget.borderRadius),
                                  ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.decelerate,
                              key: _selectKey,
                              height: 45 + (isOverlayMounted ? 1 : 0),
                              decoration: BoxDecoration(
                                color: ZwapColors.shades0,
                                borderRadius: isOverlayMounted
                                    ? openReverse
                                        ? BorderRadius.only(
                                            bottomLeft: Radius.circular(widget.borderRadius - 1),
                                            bottomRight: Radius.circular(widget.borderRadius - 1),
                                          )
                                        : BorderRadius.only(
                                            topLeft: Radius.circular(widget.borderRadius - 1),
                                            topRight: Radius.circular(widget.borderRadius - 1),
                                          )
                                    : BorderRadius.circular(widget.borderRadius - 1),
                              ),
                              margin: isOverlayMounted
                                  ? openReverse
                                      ? const EdgeInsets.only(bottom: 1, left: 1, right: 1)
                                      : const EdgeInsets.only(top: 1, left: 1, right: 1)
                                  : const EdgeInsets.all(1),
                              padding: EdgeInsets.only(
                                      left: 15,
                                      right: 5,
                                      top: 10,
                                      bottom: (widget.isMultiple && _selectedValues.isNotEmpty && !(_selectOverlay?.mounted ?? false)) ? 5 : 10) +
                                  EdgeInsets.only(
                                    bottom: isOverlayMounted && !openReverse ? 1 : 0,
                                    top: isOverlayMounted && openReverse ? 1 : 0,
                                  ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        //? Header
                                        Positioned.fill(
                                          child: AnimatedOpacity(
                                            duration: const Duration(milliseconds: 200),
                                            opacity: _showHeader ? 1 : 0,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: _showHeader
                                                  ? widget.itemBuilder!(
                                                      context,
                                                      _selectedValues.first,
                                                      _provider.values[_selectedValues.first]!,
                                                      true,
                                                    )
                                                  : Container(),
                                            ),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: AnimatedOpacity(
                                            duration: const Duration(milliseconds: 200),
                                            opacity: _showTags || _showHeader ? 0 : 1,
                                            child: IgnorePointer(
                                              ignoring: _showTags,
                                              child: Center(
                                                child: TextField(
                                                  controller: _provider._inputController,
                                                  focusNode: _provider._inputFocusNode,
                                                  readOnly: !widget.canSearch || _provider._isSmall,
                                                  decoration: InputDecoration.collapsed(hintText: widget.hintText, hintStyle: widget.hintTextStyle),
                                                  cursorColor: widget.canSearch ? ZwapColors.shades100 : ZwapColors.shades0,
                                                  keyboardType: TextInputType.none,
                                                  textInputAction: TextInputAction.go,
                                                  onSubmitted: (_) => _simulateEnter(),
                                                  onTap: _provider._isSmall ? () => _showMobileBottomSheetWrap() : null,
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
                                                      .map(
                                                        (k) => Container(
                                                          margin: const EdgeInsets.only(left: 4),
                                                          child: _ZwapSelectTag(
                                                            tagValue: _provider.values[k] ?? '',
                                                            tagKey: k,
                                                            onCancel: (k) => _provider.toggleItem(k),
                                                            itemBuilder: widget.itemBuilder,
                                                          ),
                                                        ),
                                                      )
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
                                    turns: isOverlayMounted ? 0 : 0.5,
                                    duration: const Duration(milliseconds: 150),
                                    child:
                                        Icon(Icons.keyboard_arrow_up, color: Color.fromRGBO(50, 50, 50, 1), key: ValueKey(_selectOverlay?.mounted)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.label != null && (!isOverlayMounted || !openReverse))
                  Positioned(
                    left: widget.borderRadius + 2,
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.decelerate,
                      alignment: Alignment.topLeft,
                      child: _provider._selectedValues.isNotEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                color: ZwapColors.shades0,
                                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                  ZwapColors.whiteTransparent,
                                  ZwapColors.shades0,
                                ], stops: [
                                  0,
                                  0.47
                                ]),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: ZwapText.customStyle(
                                text: widget.label!,
                                customTextStyle: getTextStyle(ZwapTextType.extraSmallBodyRegular).copyWith(
                                    color: _isHovered
                                        ? ZwapColors.primary400
                                        : (_selectOverlay?.mounted ?? false)
                                            ? ZwapColors.primary700
                                            : ZwapColors.neutral500,
                                    fontSize: 11,
                                    letterSpacing: 0.1),
                              ),
                            )
                          : Container(
                              width: textWidth(
                                widget.label!,
                                getTextStyle(ZwapTextType.extraSmallBodyRegular).copyWith(fontSize: 10, letterSpacing: 0.1),
                              ),
                              key: UniqueKey(),
                            ),
                    ),
                  ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.decelerate,
                alignment: Alignment.centerLeft,
                child: _error && widget.errorText != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 3),
                        child: ZwapText(
                          text: widget.errorText!,
                          zwapTextType: ZwapTextType.bodyRegular,
                          textColor: ZwapColors.error400,
                        ),
                      )
                    : Container(key: UniqueKey()),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _ZwapSelectTag extends StatelessWidget {
  final String tagKey;
  final String tagValue;
  final Function(String tagKey)? onCancel;
  final ItemBuilder? itemBuilder;

  const _ZwapSelectTag({
    required this.tagKey,
    required this.tagValue,
    this.onCancel,
    this.itemBuilder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ZwapColors.neutral100,
        borderRadius: BorderRadius.circular(100),
      ),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (itemBuilder == null)
            ZwapText(
              text: tagValue,
              zwapTextType: ZwapTextType.mediumBodyRegular,
              textColor: ZwapColors.primary900Dark,
              textOverflow: TextOverflow.ellipsis,
            )
          else
            itemBuilder!(context, tagKey, tagValue, true),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () => onCancel != null ? onCancel!(tagKey) : null,
            child: Center(child: ZwapIcons.icons('close', iconColor: ZwapColors.text65, iconSize: 14)),
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
                          .mapIndexed((i, key) => _SingleItemWidget(
                                isLast: catI + 1 == valuesByCategory.keys.length && i + 1 == valuesByCategory[cat]!.keys.length,
                                indent: true,
                                keyValue: key,
                                onItemTap: onItemTap,
                              ))
                          .toList(),
                    ),
                  ],
                ))
            .toList(),
      );
    }

    return Column(
      children: values.keys
          .toList()
          .mapIndexed((i, key) => _SingleItemWidget(
                isLast: i == values.keys.toList().length,
                keyValue: key,
                onItemTap: onItemTap,
                indent: false,
              ))
          .toList(),
    );
  }
}

class _SingleItemWidget extends StatefulWidget {
  final bool isLast;
  final String keyValue;

  final bool indent;

  final Function(String) onItemTap;

  const _SingleItemWidget({
    required this.isLast,
    required this.keyValue,
    required this.indent,
    required this.onItemTap,
    Key? key,
  }) : super(key: key);

  @override
  State<_SingleItemWidget> createState() => __SingleItemWidgetState();
}

class __SingleItemWidgetState extends State<_SingleItemWidget> {
  @override
  Widget build(BuildContext context) {
    final String? value = context.select<_ZwapSelectProvider, String?>((state) => state.values[widget.keyValue]);
    final bool _isHovered = context.select<_ZwapSelectProvider, bool>((state) => state.currentHoveredKey == widget.keyValue);
    final bool _isSelected = context.select<_ZwapSelectProvider, bool>((state) => state.selectedValues.contains(widget.keyValue));

    final Widget Function(BuildContext, String, String, bool)? _itemBuilder = context.read<_ZwapSelectProvider>().itemBuilder;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: Colors.transparent,
      width: double.infinity,
      height: _itemBuilder == null ? 26 : null,
      margin: EdgeInsets.only(bottom: widget.isLast ? 0 : 8),
      child: Material(
        color: _isSelected
            ? _isHovered
                ? ZwapColors.primary50
                : ZwapColors.primary100
            : _isHovered
                ? ZwapColors.neutral100
                : ZwapColors.shades0,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => widget.onItemTap(widget.keyValue),
          hoverColor: _isSelected ? ZwapColors.primary50 : ZwapColors.neutral100,
          splashColor: _isSelected ? Colors.transparent : null,
          onHover: (hovered) {
            context.read<_ZwapSelectProvider>().currentHoveredKey = hovered ? widget.keyValue : null;
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            padding:
                widget.indent ? const EdgeInsets.only(top: 3, bottom: 3, left: 17, right: 7) : const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
            child: Row(
              children: [
                Expanded(
                  child: _itemBuilder != null
                      ? _itemBuilder(context, widget.keyValue, value ?? '', false)
                      : ZwapText(
                          text: value ?? '<error>',
                          zwapTextType: ZwapTextType.bodyRegular,
                          textColor: _isSelected ? ZwapColors.primary800 : ZwapColors.shades100,
                        ),
                ),
                if (_isSelected) ...[
                  SizedBox(width: 5),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      key: ValueKey(_isHovered ? '345345345' : 'aljfngafg'),
                      child: _isHovered
                          ? Icon(Icons.close, color: ZwapColors.shades100, size: 20)
                          : Icon(Icons.check, color: ZwapColors.shades100, size: 20),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
