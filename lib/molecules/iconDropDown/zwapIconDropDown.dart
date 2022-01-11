/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

class ZwapIconDropDownsDecoration {
  //? Container decoration
  final double? height;
  final double? width;
  final ZwapTextType titleTextStyle;
  final Color backgroundColor;
  final Color titleTextColor;
  final double borderRadius;
  final EdgeInsets contentPadding;
  final Color hoverColor;

  final int titleTextSize;
  final int selectedItemTextSize;
  final int itemTextSize;

  //? Dropdown overlay decoration
  final Color itemHoverColor;
  final Color overlayBackgroundColor;
  final ZwapTextType selectedItemTextStyle;
  final ZwapTextType itemsTextStyle;
  final Color selectedItemTextColor;
  final Color itemsTextColor;
  final double overlayBorderRadius;
  final double hoverBorderRadius;
  final EdgeInsets overlayContentPadding;
  final EdgeInsets insideItemPadding;
  final double itemSpacing;
  final Color selectedItemColor;

  ///All the data have default values
  const ZwapIconDropDownsDecoration({
    this.height,
    this.width,
    ZwapTextType? titleTextStyle,
    ZwapTextType? selectedItemTextStyle,
    ZwapTextType? itemsTextStyle,
    Color? titleTextColor,
    Color? selectedItemTextColor,
    Color? itemsTextColor,
    IconData? dropdownClosedIcon,
    IconData? dropdownOpenedIcon,
    Color? backgroundColor,
    this.borderRadius = 14,
    this.hoverBorderRadius = 8,
    this.overlayBorderRadius = 14,
    Color? hoverColor,
    Color? overlayBackgroundColor,
    this.overlayContentPadding = const EdgeInsets.symmetric(horizontal: 9, vertical: 13),
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
    this.itemSpacing = 2,
    this.titleTextSize = 14,
    this.selectedItemTextSize = 14,
    this.itemTextSize = 14,
    Color? selectedItemColor,
    Color? itemHoverColor,
    this.insideItemPadding = const EdgeInsets.symmetric(horizontal: 17, vertical: 3),
  })  : this.titleTextStyle = titleTextStyle ?? ZwapTextType.captionRegular,
        this.selectedItemTextStyle = selectedItemTextStyle ?? ZwapTextType.captionRegular,
        this.itemsTextStyle = itemsTextStyle ?? ZwapTextType.captionRegular,
        this.titleTextColor = titleTextColor ?? ZwapColors.neutral700,
        this.selectedItemTextColor = selectedItemTextColor ?? ZwapColors.primary800,
        this.itemsTextColor = itemsTextColor ?? ZwapColors.neutral700,
        this.backgroundColor = backgroundColor ?? ZwapColors.shades0,
        this.hoverColor = ZwapColors.neutral100,
        this.overlayBackgroundColor = ZwapColors.shades0,
        this.itemHoverColor = ZwapColors.neutral100,
        this.selectedItemColor = ZwapColors.primary700;

  ZwapIconDropDownsDecoration copyWith({
    double? height,
    double? width,
    ZwapTextType? titleTextStyle,
    IconData? dropdownClosedIcon,
    IconData? dropdownOpenedIcon,
    Color? backgroundColor,
    Color? titleTextColor,
    double? borderRadius,
    EdgeInsets? contentPadding,
    Color? hoverColor,
    int? titleTextSize,
    int? selectedItemTextSize,
    int? itemTextSize,
    Color? itemHoverColor,
    Color? overlayBackgroundColor,
    ZwapTextType? selectedItemTextStyle,
    ZwapTextType? itemsTextStyle,
    Color? selectedItemTextColor,
    Color? itemsTextColor,
    double? overlayBorderRadius,
    double? hoverBorderRadius,
    EdgeInsets? overlayContentPadding,
    double? itemSpacing,
    Color? selectedItemColor,
  }) {
    return ZwapIconDropDownsDecoration(
      height: height ?? this.height,
      width: width ?? this.width,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleTextColor: titleTextColor ?? this.titleTextColor,
      borderRadius: borderRadius ?? this.borderRadius,
      contentPadding: contentPadding ?? this.contentPadding,
      hoverColor: hoverColor ?? this.hoverColor,
      titleTextSize: titleTextSize ?? this.titleTextSize,
      selectedItemTextSize: selectedItemTextSize ?? this.selectedItemTextSize,
      itemTextSize: itemTextSize ?? this.itemTextSize,
      itemHoverColor: itemHoverColor ?? this.itemHoverColor,
      overlayBackgroundColor: overlayBackgroundColor ?? this.overlayBackgroundColor,
      selectedItemTextStyle: selectedItemTextStyle ?? this.selectedItemTextStyle,
      itemsTextStyle: itemsTextStyle ?? this.itemsTextStyle,
      selectedItemTextColor: selectedItemTextColor ?? this.selectedItemTextColor,
      itemsTextColor: itemsTextColor ?? this.itemsTextColor,
      overlayBorderRadius: overlayBorderRadius ?? this.overlayBorderRadius,
      hoverBorderRadius: hoverBorderRadius ?? this.hoverBorderRadius,
      overlayContentPadding: overlayContentPadding ?? this.overlayContentPadding,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
    );
  }
}

/// Custom dropdown with a list of values with emoji and text values
class ZwapIconDropDowns extends StatefulWidget {
  /// The items to display inside this dropdown
  final Map<String, String> emojiItems;

  /// CallBack function on selecting item
  final Function(String selectedItem) onSelectCallBack;

  /// The optional preselected item
  final String? selectedItem;

  final ZwapIconDropDownsDecoration decoration;

  ZwapIconDropDowns({Key? key, required this.emojiItems, required this.onSelectCallBack, this.selectedItem, this.decoration = const ZwapIconDropDownsDecoration()}) : super(key: key);

  _ZwapIconDropDownsState createState() => _ZwapIconDropDownsState(this.selectedItem);
}

/// The state for this custom widget
class _ZwapIconDropDownsState extends State<ZwapIconDropDowns> {
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _dropdownOverlay;

  /// The item hovered
  String _hoveredItem = "";

  /// The selected item
  String _selectedItem = "";

  /// Is the dropdown open or closed
  bool _isDropdownOpen = false;

  _ZwapIconDropDownsState(String? preSelectedItem) {
    if (preSelectedItem != null) {
      this._selectedItem = preSelectedItem;
    }
  }

  /// It selects the item from the dropdown values
  void _selectItem(String key) {
    setState(() {
      this._selectedItem = key;
    });
    this._toggleOverlay();
    widget.onSelectCallBack(key);
  }

  /// It handles the hover on some item
  void _hoverItem(String key) {
    setState(() {
      this._hoveredItem = key;
    });
  }

  /// It gets the selected item
  String get selectedItem => this._selectedItem.trim() != "" ? this._selectedItem : widget.emojiItems.keys.toList().first;

  /// It builds the row item to display inside the emoji dropdown
  Widget _rowItem(String char, String itemName, bool isDropdownWidget) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        color: !isDropdownWidget && (itemName == this.selectedItem || itemName == this._hoveredItem) ? ZwapColors.primary100 : ZwapColors.shades0,
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Flexible(
              flex: 0,
              fit: FlexFit.tight,
              child: Padding(
                padding: EdgeInsets.only(right: 3),
                child: ZwapText(
                  text: char.emojiChar(),
                  textColor: ZwapColors.error400,
                  zwapTextType: ZwapTextType.h3,
                ),
              ),
            ),
            Flexible(
              flex: 0,
              fit: FlexFit.tight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ZwapText(
                  text: itemName,
                  textColor: ZwapColors.neutral700,
                  zwapTextType: ZwapTextType.bodyRegular,
                ),
              ),
            ),
            isDropdownWidget
                ? Flexible(
                    flex: 0,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: EdgeInsets.only(left: 3),
                      child: Icon(this._isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void _toggleOverlay() {
    if (_dropdownOverlay?.mounted ?? false)
      _dropdownOverlay!.remove();
    else
      Overlay.of(context)?.insert(_dropdownOverlay = _createOverlay());
  }

  OverlayEntry _createOverlay() {
    final ZwapIconDropDownsDecoration decorations = widget.decoration;

    return OverlayEntry(
      builder: (context) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          top: (_dropdownKey.globalOffset?.dy ?? 0) + (decorations.height ?? 5) + 5,
          left: (_dropdownKey.globalOffset?.dx ?? 0) - 10,
          child: Container(
            width: decorations.width == null ? null : decorations.width! + 20,
            decoration: BoxDecoration(
              color: decorations.overlayBackgroundColor,
              borderRadius: BorderRadius.circular(decorations.overlayBorderRadius),
            ),
            padding: decorations.overlayContentPadding,
            child: Column(
              children: widget.emojiItems.keys
                  .toList()
                  .map((k) => Material(
                        color: k == this.selectedItem ? decorations.selectedItemColor : decorations.overlayBackgroundColor,
                        child: InkWell(
                          onTap: k != this.selectedItem ? () => this._selectItem(k) : null,
                          borderRadius: BorderRadius.circular(decorations.hoverBorderRadius),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(decorations.hoverBorderRadius),
                            ),
                            padding: decorations.insideItemPadding,
                            child: Row(
                              children: [
                                ZwapText(
                                  text: k.emojiChar(),
                                  textColor: ZwapColors.error400,
                                  zwapTextType: ZwapTextType.h3,
                                ),
                                SizedBox(width: 20),
                                ZwapText(
                                  text: widget.emojiItems[k]!,
                                  textColor: k == this.selectedItem ? decorations.selectedItemTextColor : decorations.itemsTextColor,
                                  zwapTextType: k == this.selectedItem ? decorations.selectedItemTextStyle : decorations.itemsTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ZwapIconDropDownsDecoration decorations = widget.decoration;

    return Material(
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
              ZwapText(
                text: this.selectedItem.emojiChar(),
                textColor: ZwapColors.error400,
                zwapTextType: ZwapTextType.h3,
              ),
              SizedBox(width: 20),
              ZwapText(
                text: widget.emojiItems[this.selectedItem]!,
                textColor: ZwapColors.neutral700,
                zwapTextType: ZwapTextType.bodyRegular,
              ),
              SizedBox(width: 20),
              AnimatedRotation(
                turns: this._isDropdownOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: Icon(Icons.arrow_drop_up, color: Color.fromRGBO(50, 50, 50, 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//TODO: sposta in file a parte
extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }

  Offset? get globalOffset {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) return Offset(translation.x, translation.y);
    return null;
  }
}
