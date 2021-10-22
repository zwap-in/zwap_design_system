/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/colStrap/colStrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// Custom component to render a tag button component
class ZwapTag extends StatefulWidget implements ResponsiveWidget{

  /// The text inside this component
  final String tagText;

  /// The custom callBack function on click on clear icon
  final Function() onCallBackClick;

  /// Is it selected or not
  final bool isSelected;

  /// Custom boolean flag to check if this custom tag has the clear icon to remove it
  final bool hasIcon;

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

  ZwapTag({Key? key,
    required this.tagText,
    required this.onCallBackClick,
    this.isSelected = false,
    this.hasIcon = true,
    this.tagColor,
    this.selectedTagColor,
    this.hoverTagColor,
    this.tagTextColor,
    this.selectedTagTextColor,
    this.hoverTagTextColor,
    this.iconSize
  }) : super(key: key);

  _ZwapTagState createState() => _ZwapTagState();

  @override
  double getSize() {
    return getTextSize(this.tagText, ZwapTextType.body1Regular).width + 10 + 20;
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

  @override
  Widget build(BuildContext context) {
    Widget textChildWidget = Padding(
      padding: EdgeInsets.all(4),
      child: ZwapText(
        text: widget.tagText,
        textColor: this._getChildrenColor(),
        zwapTextType: ZwapTextType.buttonText,
      ),
    );
    return InkWell(
      onTap: () => widget.onCallBackClick(),
      onHover: (bool isHover) => this._handleHover(isHover),
      child: Container(
          decoration: BoxDecoration(
              color: this._getBackGroundColor(),
              borderRadius: BorderRadius.all(Radius.circular(ZwapRadius.buttonRadius))
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: widget.hasIcon ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: textChildWidget,
                  fit: FlexFit.tight,
                  flex: 0,
                ),
                Flexible(
                  child: Icon(
                    Icons.clear,
                    color: this._getChildrenColor(),
                    size: widget.iconSize ?? 16,
                  ),
                  flex: 0,
                  fit: FlexFit.tight,
                )
              ],
            ) : textChildWidget,
          )
      ),
    );
  }
}
