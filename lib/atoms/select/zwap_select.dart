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
    this.borderRadius = 4,
    this.searchType = ZwapSelectSearchTypes.dynamic,
    this.searchDelayDuration,
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
    this.borderRadius = 4,
    this.searchDelayDuration,
    this.searchType = ZwapSelectSearchTypes.dynamic,
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
    this.borderRadius = 4,
    this.searchType = ZwapSelectSearchTypes.dynamic,
    this.searchDelayDuration,
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
    this.borderRadius = 4,
    this.searchType = ZwapSelectSearchTypes.dynamic,
    this.searchDelayDuration,
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
  late final _ZwapSelectProvider _provider;

  /// If [true] the select input is hovered
  bool _isHovered = false;

  /// Object for select overlay control
  OverlayEntry? _selectOverlay;

  List<String> get categories => widget.valuesByCategory.keys.toList();

  @override
  void initState() {
    super.initState();

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
    );
  }

  @override
  void didUpdateWidget(covariant ZwapSelect oldWidget) {
    if (widget.fetchMoreData == null && !mapEquals(oldWidget.values, widget.values)) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => _provider.originalValuesChanged(widget.values));
    }
    if (widget.isRegular && widget.selected != oldWidget.selected)
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (!_provider.selectedValues.contains(widget.selected)) {
          _provider.toggleItem(widget.selected, callWidgetCallback: false);
        }
      });
    if (widget.isMultiple && !listEquals(widget.selectedValues, oldWidget.selectedValues))
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _provider.selectedChanged(widget.selectedValues);
      });

    super.didUpdateWidget(oldWidget);
  }

  /// This method wrap _showMobileBottomSheet(...) method
  Future<void> _showMobileBottomSheetWrap() async {
    return _showMobileBottomSheet(context, _provider);
  }

  void _toggleOverlay() {
    if (_selectOverlay?.mounted ?? false) {
      try {
        _selectOverlay!.remove();
      } catch (e) {}
      _selectOverlay = null;
    } else {
      Overlay.of(context)?.insert(_selectOverlay = _createOverlay());
      // if (!_inputFocus.hasFocus) _inputFocus.requestFocus();
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
                onAutoClose: () => _provider.toggleOverlay(),
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
                                              child: _isLoading
                                                  ? LinearProgressIndicator(
                                                      valueColor: AlwaysStoppedAnimation(ZwapColors.primary800),
                                                      minHeight: 2,
                                                    )
                                                  : Container(),
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
                                          child: _isLoading
                                              ? LinearProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation(ZwapColors.primary800),
                                                  minHeight: 2,
                                                )
                                              : SizedBox(height: 13),
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
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Builder(builder: (context) {
        final List<String> _selectedValues = context.select<_ZwapSelectProvider, List<String>>((state) => state.selectedValues);
        final bool _showTags = !_provider._inputFocusNode.hasFocus && widget.isMultiple && _selectedValues.isNotEmpty;

        return GestureDetector(
          onTap: _provider._isSmall ? () => _showMobileBottomSheet(context, _provider) : null,
          behavior: _provider._isSmall ? HitTestBehavior.opaque : HitTestBehavior.translucent,
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
                                              .map((k) => Container(
                                                    margin: const EdgeInsets.only(left: 4),
                                                    child: _ZwapTag(
                                                      tagValue: _provider.values[k] ?? '',
                                                      tagKey: k,
                                                      onCancel: (k) => _provider.toggleItem(k),
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
              ),
            ],
          ),
        );
      }),
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: Colors.transparent,
      width: double.infinity,
      height: 26,
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
                  child: ZwapText(
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
