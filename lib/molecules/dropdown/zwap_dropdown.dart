/// IMPORTING THIRD PARTY PACKAGES
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

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

  final ZwapDropDownDecoration decoration;

  ZwapDropDown({Key? key, required this.head, required this.items, required this.onSelectCallBack, this.selectedItem, this.decoration = const ZwapDropDownDecoration(), this.showArrow = true})
      : super(key: key);

  _ZwapDropDownState createState() => _ZwapDropDownState();
}

/// The state for this custom widget
class _ZwapDropDownState extends State<ZwapDropDown> {
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _dropdownOverlay;

  /// The item hovered
  String _hoveredItem = "";

  /// The selected item
  String? _selectedItem;

  @override
  void initState() {
    super.initState();

    if (widget.selectedItem != null) {
      this._selectedItem = widget.selectedItem!;
    }
  }

  @override
  void didUpdateWidget(covariant ZwapDropDown oldWidget) {
    if (widget.selectedItem != widget.selectedItem) setState(() => _selectedItem = widget.selectedItem);

    super.didUpdateWidget(oldWidget);
  }

  void hideOverlay() => this._dropdownOverlay?.remove();

  /// It selects the item from the dropdown values
  void _selectItem(String key) {
    this._toggleOverlay();
    widget.onSelectCallBack(key);
    setState(() {});
  }

  /// It handles the hover on some item
  void _hoverItem(String key) {
    setState(() {
      this._hoveredItem = key;
    });
  }

  /// It gets the selected item

  void _toggleOverlay() {
    if (_dropdownOverlay?.mounted ?? false) {
      _dropdownOverlay!.remove();
      _dropdownOverlay = null;
    } else
      Overlay.of(context)?.insert(_dropdownOverlay = _createOverlay());

    setState(() {});
  }

  OverlayEntry _createOverlay() {
    final ZwapDropDownDecoration decorations = widget.decoration;

    return OverlayEntry(
      builder: (context) {
        return ZwapOverlayEntryWidget(
          entity: _dropdownOverlay,
          onAutoClose: () => setState(() => _dropdownOverlay = null),
          child: ZwapOverlayEntryChild(
            top: (_dropdownKey.globalOffset?.dy ?? 0) + (decorations.height ?? 50) + 5 + decorations.overlayTranslateOffset.dy,
            left: (_dropdownKey.globalOffset?.dx ?? 0) - 10 + decorations.overlayTranslateOffset.dx,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 350),
              curve: Curves.decelerate,
              tween: Tween(begin: 0, end: 1),
              builder: (context, animation, child) => Opacity(
                opacity: animation,
                child: Container(
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
                  child: Column(
                    crossAxisAlignment: decorations.itemsAlignment,
                    children: widget.items.keys
                        .toList()
                        .mapIndexed((i, k) => Container(
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
                                  onHover: (val) => val ? _hoverItem(k) : _hoverItem(''),
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
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ZwapDropDownDecoration decorations = widget.decoration;

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (k) => k.logicalKey == LogicalKeyboardKey.escape && (_dropdownOverlay?.mounted ?? false) ? _toggleOverlay() : null,
      child: Material(
        color: decorations.backgroundColor,
        borderRadius: BorderRadius.circular(decorations.borderRadius),
        child: InkWell(
          hoverColor: decorations.hoverColor,
          borderRadius: BorderRadius.circular(decorations.borderRadius),
          onTap: () => _toggleOverlay(),
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
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    key: ValueKey(this._selectedItem),
                    child: widget.head,
                  ),
                ),
                if (widget.showArrow) ...[
                  Spacer(),
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
      ),
    );
  }
}
