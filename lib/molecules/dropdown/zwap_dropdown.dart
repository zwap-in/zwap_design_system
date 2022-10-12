/// IMPORTING THIRD PARTY PACKAGES
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:provider/provider.dart';

class _ZwapDropDownProvider extends ChangeNotifier {
  Map<String, Widget> _items = {};
  String _filterValue = '';
  bool _showTextField = false;

  Map<String, Widget> get items => _items;
  String get filterValue => _filterValue;
  bool get showTextField => _showTextField;

  set items(Map<String, Widget> value) => !mapEquals(value, _items) ? {_items = value, notifyListeners()} : null;
  set filterValue(String value) => _filterValue != value ? {_filterValue = value, notifyListeners()} : null;
  set showTextField(bool value) => _showTextField != value ? {_showTextField = value, notifyListeners()} : null;

  void addAll(Map<String, Widget> newItems) {
    _items.addAll(newItems);
    notifyListeners();
  }
}

class ZwapDropDownDecoration {
  //? Container decoration
  final double? height;
  final double? width;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets contentPadding;
  final Color hoverColor;

  final Offset overlayTranslateOffset;

  //? Dropdown overlay decoration
  final Color itemHoverColor;
  final Color overlayBackgroundColor;
  final double overlayBorderRadius;
  final double hoverBorderRadius;
  final EdgeInsets overlayContentPadding;
  final EdgeInsets insideItemPadding;
  final double itemSpacing;
  final Color selectedItemColor;

  final double? overlayWidth;
  final CrossAxisAlignment itemsAlignment;

  ///All the data have default values
  const ZwapDropDownDecoration({
    this.height,
    this.width,
    Color? backgroundColor,
    this.borderRadius = 14,
    this.hoverBorderRadius = 8,
    this.overlayBorderRadius = 14,
    Color? hoverColor,
    Color? overlayBackgroundColor,
    this.overlayContentPadding = const EdgeInsets.symmetric(horizontal: 9, vertical: 13),
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
    this.itemSpacing = 2,
    this.overlayTranslateOffset = const Offset(0, 0),
    this.insideItemPadding = const EdgeInsets.symmetric(horizontal: 17, vertical: 3),
    Color? selectedItemColor,
    Color? itemHoverColor,
    this.overlayWidth,
    this.itemsAlignment = CrossAxisAlignment.start,
  })  : this.backgroundColor = backgroundColor ?? ZwapColors.shades0,
        this.hoverColor = hoverColor ?? ZwapColors.neutral100,
        this.overlayBackgroundColor = overlayBackgroundColor ?? ZwapColors.shades0,
        this.itemHoverColor = itemHoverColor ?? ZwapColors.neutral100,
        this.selectedItemColor = selectedItemColor ?? ZwapColors.primary100;

  factory ZwapDropDownDecoration.collapsed({
    double? height,
    double? width,
    double hoverBorderRadius = 8,
    double overlayBorderRadius = 14,
    Color? hoverColor,
    Color? overlayBackgroundColor,
    EdgeInsets overlayContentPadding = const EdgeInsets.symmetric(horizontal: 9, vertical: 13),
    double itemSpacing = 2,
    Offset overlayTranslateOffset = const Offset(0, 0),
    EdgeInsets insideItemPadding = const EdgeInsets.symmetric(horizontal: 17, vertical: 3),
    Color? selectedItemColor,
    Color? itemHoverColor,
    double? overlayWidth,
    CrossAxisAlignment? itemsAlignment,
  }) =>
      ZwapDropDownDecoration(
        height: height,
        width: width,
        hoverColor: hoverColor,
        overlayBackgroundColor: overlayBackgroundColor,
        overlayContentPadding: overlayContentPadding,
        contentPadding: EdgeInsets.zero,
        itemSpacing: itemSpacing,
        overlayTranslateOffset: overlayTranslateOffset,
        insideItemPadding: insideItemPadding,
        selectedItemColor: selectedItemColor,
        itemHoverColor: itemHoverColor,
        backgroundColor: Colors.transparent,
        hoverBorderRadius: hoverBorderRadius,
        overlayBorderRadius: overlayBorderRadius,
        overlayWidth: overlayWidth,
        itemsAlignment: itemsAlignment ?? CrossAxisAlignment.start,
      );

  ZwapDropDownDecoration copyWith({
    double? height,
    double? width,
    Color? backgroundColor,
    double? borderRadius,
    EdgeInsets? contentPadding,
    Color? hoverColor,
    Offset? overlayTranslateOffset,
    Color? itemHoverColor,
    Color? overlayBackgroundColor,
    double? overlayBorderRadius,
    double? hoverBorderRadius,
    EdgeInsets? overlayContentPadding,
    EdgeInsets? insideItemPadding,
    double? itemSpacing,
    Color? selectedItemColor,
  }) {
    return ZwapDropDownDecoration(
      height: height ?? this.height,
      width: width ?? this.width,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      contentPadding: contentPadding ?? this.contentPadding,
      hoverColor: hoverColor ?? this.hoverColor,
      overlayTranslateOffset: overlayTranslateOffset ?? this.overlayTranslateOffset,
      itemHoverColor: itemHoverColor ?? this.itemHoverColor,
      overlayBackgroundColor: overlayBackgroundColor ?? this.overlayBackgroundColor,
      overlayBorderRadius: overlayBorderRadius ?? this.overlayBorderRadius,
      hoverBorderRadius: hoverBorderRadius ?? this.hoverBorderRadius,
      overlayContentPadding: overlayContentPadding ?? this.overlayContentPadding,
      insideItemPadding: insideItemPadding ?? this.insideItemPadding,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
    );
  }
}

/// Custom dropdown with a list of values with emoji and text values
class ZwapDropDown extends StatefulWidget {
  final Widget head;

  /// The items to display inside this dropdown
  final Map<String, Widget> items;

  /// CallBack function on selecting item
  final Function(String selectedItem) onSelectCallBack;

  /// The optional preselected item
  final String? selectedItem;

  final bool showArrow;

  /// If provided when scroll controller hits the end will be called to get more items
  ///
  /// [page] will start from 2
  ///
  /// If [caSearch] is true: called each time users stop write for more than 800 ms
  ///
  /// If text is not empty page will restartet from 1. Empty page number is cached
  ///
  /// If result is empty page will not be incremented
  final FutureOr<Map<String, Widget>> Function(String text, int page)? getMoreItems;

  /// If [canSearch] is true users will be able to write inside the dropdown and filter items
  ///
  /// [head] is showed if search text is empty
  final bool canSearch;

  final ZwapDropDownDecoration decoration;

  /// If not null, when there are not items to display a text with this message will printed
  final String? noResultMessage;

  /// If provided and can search is true, assigned to text input
  final FocusNode? focusNode;

  /// Used to sort keys and consequently sort widgets
  final int Function(String a, String b)? sortKeys;

  final FutureOr<void> Function(bool hasFocus)? onFocusChange;

  ZwapDropDown({
    Key? key,
    required this.head,
    required this.items,
    required this.onSelectCallBack,
    this.selectedItem,
    this.decoration = const ZwapDropDownDecoration(),
    this.showArrow = true,
    this.getMoreItems,
    this.canSearch = false,
    this.noResultMessage,
    this.focusNode,
    this.sortKeys,
    this.onFocusChange,
  }) : super(key: key);

  _ZwapDropDownState createState() => _ZwapDropDownState();
}

/// The state for this custom widget
class _ZwapDropDownState extends State<ZwapDropDown> {
  final GlobalKey _dropdownKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  late final FocusNode _inputFocusNode;
  final ScrollController _scrollController = ScrollController();

  late final _ZwapDropDownProvider _provider;

  OverlayEntry? _dropdownOverlay;

  //? For manage search
  int _fetchItemsPage = 2;
  String _lastSearchedString = '';
  int _lastCustomSearchPage = 1;

  bool _isLoading = false;

  String? _hoveredItem;

  /// The selected item
  String? _selectedItem;

  @override
  void initState() {
    super.initState();

    _provider = _ZwapDropDownProvider()..items = widget.items;

    if (widget.selectedItem != null) this._selectedItem = widget.selectedItem!;

    _inputFocusNode = (widget.focusNode ?? FocusNode())
      ..onKey = (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.escape && (_dropdownOverlay?.mounted ?? false)) {
          _toggleOverlay();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      };

    _scrollController.addListener(_scrollListener);
    _searchController.addListener(_controllerListener);
    _inputFocusNode.addListener(_focusListener);
  }

  @override
  void didUpdateWidget(covariant ZwapDropDown oldWidget) {
    if (widget.selectedItem != widget.selectedItem) setState(() => _selectedItem = widget.selectedItem);
    if (widget.items.length != oldWidget.items.length) _provider.addAll(widget.items);

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _inputFocusNode.removeListener(_focusListener);
    super.dispose();
  }

  void _scrollListener() {
    if (widget.getMoreItems == null) return;

    if (_scrollController.position.atEdge && _scrollController.position.pixels != 0 && !!_isLoading && !_scrollController.position.outOfRange)
      _fetchMoreItems();
  }

  void _controllerListener() {
    _provider.filterValue = _searchController.text;
    _provider.showTextField = widget.canSearch && _searchController.text.isNotEmpty;
  }

  void _focusListener() async {
    if (_dropdownOverlay?.mounted ?? false) {
      _searchController.text = '';
      _inputFocusNode.unfocus();
    }
  }

  void hideOverlay() => this._dropdownOverlay?.remove();

  /// It selects the item from the dropdown values
  void _selectItem(String key) {
    this._toggleOverlay();
    _searchController.text = '';
    _inputFocusNode.unfocus();
    widget.onSelectCallBack(key);
    setState(() {});
  }

  void _toggleOverlay() async {
    if (_dropdownOverlay?.mounted ?? false) {
      _dropdownOverlay!.remove();
      _dropdownOverlay = null;
    } else {
      if (!_inputFocusNode.hasFocus) {
        if (widget.onFocusChange != null) await widget.onFocusChange!(true);
        _inputFocusNode.requestFocus();
      }
      Overlay.of(context)?.insert(_dropdownOverlay = _createOverlay());
    }

    setState(() {});
  }

  OverlayEntry _createOverlay() {
    return OverlayEntry(
      builder: (context) {
        final ZwapDropDownDecoration decorations = widget.decoration;

        return ZwapOverlayEntryWidget(
          entity: _dropdownOverlay,
          onAutoClose: () {
            _inputFocusNode.unfocus();
            _searchController.text = '';
            setState(() => _dropdownOverlay = null);
          },
          child: ZwapOverlayEntryChild(
            top: (_dropdownKey.globalOffset?.dy ?? 0) + (decorations.height ?? 50) + 5 + decorations.overlayTranslateOffset.dy,
            left: (_dropdownKey.globalOffset?.dx ?? 0) - 10 + decorations.overlayTranslateOffset.dx,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 350),
              curve: Curves.decelerate,
              tween: Tween(begin: 0, end: 1),
              builder: (context, animation, child) => Opacity(
                opacity: animation,
                child: ChangeNotifierProvider.value(
                  value: _provider,
                  builder: (context, provider) {
                    final Map<String, Widget> _items = context.select<_ZwapDropDownProvider, Map<String, Widget>>((pro) => pro.items);
                    final Map<String, Widget> _showedItems = Map.from(_items)
                      ..removeWhere((k, v) => !k.toLowerCase().trim().contains(_searchController.text.toLowerCase().trim()));

                    return Container(
                      constraints: BoxConstraints(maxHeight: 300),
                      width: decorations.overlayWidth != null
                          ? decorations.overlayWidth
                          : decorations.width == null
                              ? null
                              : decorations.width! + 20,
                      decoration: BoxDecoration(
                        color: decorations.overlayBackgroundColor,
                        borderRadius: BorderRadius.circular(decorations.overlayBorderRadius),
                        boxShadow: [ZwapShadow.levelOne],
                      ),
                      padding: decorations.overlayContentPadding,
                      child: _showedItems.isEmpty && widget.noResultMessage != null
                          ? Material(
                              color: Colors.transparent,
                              child: Container(
                                height: 30,
                                alignment: Alignment.center,
                                child: Text(
                                  widget.noResultMessage!,
                                  style: getTextStyle(ZwapTextType.mediumBodyRegular).copyWith(color: ZwapColors.neutral900),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              controller: _scrollController,
                              child: Column(
                                crossAxisAlignment: decorations.itemsAlignment,
                                children: (widget.sortKeys == null ? _showedItems.keys.toList() : _showedItems.keys.toList()
                                      ..sort(widget.sortKeys))
                                    .mapIndexed(
                                      (i, k) => Container(
                                        color: Colors.transparent,
                                        width: (decorations.overlayWidth != null
                                            ? decorations.overlayWidth
                                            : decorations.width == null
                                                ? null
                                                : decorations.width! + 20 - (decorations.contentPadding.left + decorations.contentPadding.right)),
                                        margin: EdgeInsets.only(bottom: i != (widget.items.keys.toList().length - 1) ? decorations.itemSpacing : 0),
                                        child: Material(
                                          color: k == _selectedItem
                                              ? decorations.selectedItemColor
                                              : k == _hoveredItem
                                                  ? decorations.itemHoverColor
                                                  : decorations.overlayBackgroundColor,
                                          borderRadius: BorderRadius.circular(decorations.hoverBorderRadius),
                                          child: InkWell(
                                            onTap: k != _selectedItem ? () => this._selectItem(k) : null,
                                            hoverColor: decorations.itemHoverColor,
                                            onHover: (val) => val ? _hoveredItem = k : _hoveredItem = null,
                                            borderRadius: BorderRadius.circular(decorations.hoverBorderRadius),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.circular(decorations.hoverBorderRadius),
                                              ),
                                              padding: decorations.insideItemPadding,
                                              child: widget.items[k],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _fetchMoreItems() async {
    if (widget.getMoreItems == null) return;
    _isLoading = true;

    int _page = _fetchItemsPage;

    if (_searchController.text.isNotEmpty) {
      if (_searchController.text == _lastSearchedString)
        _page = _lastCustomSearchPage;
      else
        _page = (_lastCustomSearchPage = 1);
    }

    Map<String, Widget> _newItems = await widget.getMoreItems!(_searchController.text, _page);

    if (_newItems.isEmpty) {
      _isLoading = false;
      return;
    }

    if (_searchController.text.isEmpty)
      _fetchItemsPage++;
    else
      _lastCustomSearchPage++;

    _provider.addAll(_newItems);
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final ZwapDropDownDecoration decorations = widget.decoration;

    return ChangeNotifierProvider.value(
      value: _provider,
      builder: (context, provider) {
        final bool _showTextFiels = context.select<_ZwapDropDownProvider, bool>((pro) => pro.showTextField);

        return Material(
          color: decorations.backgroundColor,
          borderRadius: BorderRadius.circular(decorations.borderRadius),
          child: InkWell(
            hoverColor: decorations.hoverColor,
            borderRadius: BorderRadius.circular(decorations.borderRadius),
            onTap: () {
              if (_dropdownOverlay?.mounted != true) _toggleOverlay();
            },
            child: Container(
              key: _dropdownKey,
              width: decorations.width,
              height: decorations.height ?? 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(decorations.borderRadius),
              ),
              padding: decorations.contentPadding,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Stack(
                      children: [
                        if (!_showTextFiels)
                          GestureDetector(
                            onTap: () {
                              if (_dropdownOverlay?.mounted != true) _toggleOverlay();
                            },
                            child: Container(
                              key: ValueKey(this._selectedItem),
                              child: widget.head,
                            ),
                          ),
                        if (widget.canSearch)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              controller: _searchController,
                              focusNode: _inputFocusNode,
                              enabled: widget.canSearch,
                              style: getTextStyle(ZwapTextType.mediumBodyRegular).copyWith(color: ZwapColors.neutral900),
                              decoration: InputDecoration.collapsed(hintText: ""),
                              maxLines: 1,
                              cursorColor: ZwapColors.primary700,
                              mouseCursor: SystemMouseCursors.basic,
                              onTap: () {
                                if (_dropdownOverlay?.mounted != true) _toggleOverlay();
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.showArrow) ...[
                    AnimatedRotation(
                      turns: (this._dropdownOverlay?.mounted ?? false) ? 0 : 0.5,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(Icons.keyboard_arrow_up, color: Color.fromRGBO(50, 50, 50, 1), key: ValueKey(this._dropdownOverlay != null)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
