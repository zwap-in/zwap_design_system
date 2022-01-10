/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';
import 'package:zwap_design_system/atoms/constants/zwapConstants.dart';
import 'package:zwap_design_system/atoms/icons/zwapIcons.dart';
import 'package:zwap_design_system/atoms/typography/zwapTypography.dart';
import 'package:zwap_design_system/atoms/text/text.dart';

import 'tagTypes/zwapTagTypes.dart';
export 'tagTypes/zwapTagTypes.dart';

/// Custom component to render a tag button component
class ZwapTag extends StatefulWidget implements ResponsiveWidget{

  /// The text inside this component
  final String tagText;

  /// The type for this tag component
  final ZwapTagType zwapTagType;

  /// The content type for this component
  final ZwapTagContentType zwapContentType;

  /// The possible icon type
  final ZwapIconType? zwapIconType;

  /// Is it selected or not
  final bool isSelected;

  /// The custom callBack function on click on clear icon
  final Function()? onCallBackClick;

  /// The tag color for this custom tag component
  final Color? tagColor;

  /// The selected tag color for this custom tag component
  final Color? selectedTagColor;

  /// The hover tag color for this custom tag component
  final Color? hoverTagColor;

  /// The tag text color for this custom tag component
  final Color? tagTextColor;

  /// The hover color for this custom tag component
  final Color? hoverTagTextColor;

  /// The selected tag text color for this custom tag component
  final Color? selectedTagTextColor;

  /// The optional icon size
  final double? iconSize;

  /// The optional icon color
  final Color? iconColor;

  /// The icon widget for the widget rendering in case of iconType with value as widgetIcon
  final IconData? iconWidget;

  /// The name for the icon with the zwap icons assets in case of iconType with value as zwapIcon
  final String? iconName;

  ZwapTag({Key? key,
    required this.tagText,
    required this.zwapTagType,
    required this.zwapContentType,
    this.zwapIconType,
    this.isSelected = false,
    this.onCallBackClick,
    this.tagColor,
    this.selectedTagColor,
    this.hoverTagColor,
    this.tagTextColor,
    this.selectedTagTextColor,
    this.hoverTagTextColor,
    this.iconSize,
    this.iconColor,
    this.iconWidget,
    this.iconName
  }) : super(key: key){
    if(this.zwapTagType == ZwapTagType.static){
      assert(this.onCallBackClick == null, "The callBack click must be null on tag type static");
    }
    else{
      assert(this.onCallBackClick != null, "The callBack click must be not null on tag type clickable");
    }
    if(this.zwapContentType == ZwapTagContentType.noIcon){
      assert(this.zwapIconType == null, "The icon type must be null on no icon inside this tag");
    }
    else{
      assert(this.zwapIconType != null, "The icon type must be not null on content type with some icon conditions");
      if(this.zwapIconType == ZwapIconType.widgetIcon){
        assert(this.iconWidget != null, "The icon widget must be not null on widgetIcon type for icon type");
        assert(this.iconName == null, "The icon name must be null on widgetIcon type for icon type");
      }
      else {
        assert(this.iconWidget ==
            null, "The icon widget must be null on zwapIcon type for icon type");
        assert(this.iconName !=
            null, "The icon name must be not null on zwapIcon type for icon type");
      }
    }
  }

  _ZwapTagState createState() => _ZwapTagState();

  @override
  double getSize() {
    return getTextSize(this.tagText, ZwapTextType.bodyRegular).width + 10 + 20;
  }
}

/// Custom component to render a custom tag with the standard style
class _ZwapTagState extends State<ZwapTag> {

  bool _isHovered = false;

  void _handleHover(bool isHovered){
    setState(() {
      this._isHovered = isHovered;
    });
  }

  /// It retrieves the background color in base of the status and type
  Color _getBackGroundColor() {
    Color backgroundColor;
    if(widget.isSelected){
      backgroundColor = widget.selectedTagColor ?? ZwapColors.primary800;
    }
    else if(this._isHovered){
      backgroundColor = widget.hoverTagColor ?? ZwapColors.primary200;
    }
    else{
      backgroundColor = widget.tagColor ?? ZwapColors.primary100;
    }
    return backgroundColor;
  }

  /// It retrieves the children color inside this component
  Color _getChildrenColor() {
    Color textColor;
    if(widget.isSelected){
      textColor = widget.tagTextColor ?? ZwapColors.shades0;
    }
    else if(this._isHovered){
      textColor = widget.hoverTagTextColor ?? ZwapColors.primary700;
    }
    else{
      textColor = widget.tagColor ?? ZwapColors.primary400;
    }
    return textColor;
  }

  /// It gets the text widget for this tag component
  Widget get _textWidget => Padding(
    padding: EdgeInsets.all(4),
    child: ZwapText(
      text: widget.tagText,
      textColor: this._getChildrenColor(),
      zwapTextType: ZwapTextType.buttonText,
    ),
  );

  /// It gets the icon widget for this tag component
  Widget get _iconWidget => widget.zwapContentType != ZwapTagContentType.noIcon ? (widget.zwapIconType == ZwapIconType.widgetIcon ?
        Icon(
          widget.iconWidget!,
          color: widget.iconColor,
          size: widget.iconSize,
        )
      : ZwapIcons.icons(widget.iconName!, iconSize: widget.iconSize, iconColor: widget.iconColor)) : Container();

  /// It gets the icon text tag widget for this tag component
  Widget get _iconTextTagWidget => Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Flexible(
        child: widget.zwapContentType == ZwapTagContentType.leftIcon ? Padding(
          padding: EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 5),
          child: this._iconWidget,
        ) : Container(),
        flex: 0,
        fit: FlexFit.tight,
      ),
      Flexible(
        child: Padding(
          padding: EdgeInsets.only(left: 5, right: 8, top: 5, bottom: 5),
          child: this._textWidget,
        ),
        flex: 0,
        fit: FlexFit.tight,
      ),
      Flexible(
        child: widget.zwapContentType == ZwapTagContentType.rightIcon ? Padding(
          padding: EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 5),
          child: this._iconWidget,
        ) : Container(),
        flex: 0,
        fit: FlexFit.tight,
      ),
    ],
  );

  /// It builds the body widget for this tag component
  Widget get _tagBodyWidget => Container(
      decoration: BoxDecoration(
          color: this._getBackGroundColor(),
          borderRadius: BorderRadius.all(Radius.circular(ZwapRadius.defaultRadius))
      ),
      child: widget.zwapContentType == ZwapTagContentType.noIcon ? this._textWidget : this._iconTextTagWidget
  );

  @override
  Widget build(BuildContext context) {
    return widget.zwapTagType == ZwapTagType.clickable ? InkWell(
    onTap: () => widget.onCallBackClick!(),
    onHover: (bool isHover) => this._handleHover(isHover),
    child: this._tagBodyWidget,
    ) : this._tagBodyWidget;
  }
}
