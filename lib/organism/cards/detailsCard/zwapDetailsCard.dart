/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

/// Details card about a profile with a text info and optionally an image component
class ZwapDetailsCard extends StatefulWidget{

  /// Is this card selected?
  final bool isSelected;

  /// The title text for this card
  final String title;

  /// The subtitle widget for this card
  final Widget subTitle;

  /// The optionally image path
  final String? imagePath;

  /// Is this image an external asset?
  final bool isExternalImage;

  ZwapDetailsCard({Key? key,
    required this.isSelected,
    required this.title,
    required this.subTitle,
    this.imagePath,
    this.isExternalImage = false
  }): super(key: key);

  _ZwapDetailsCardState createState() => _ZwapDetailsCardState();


}

class _ZwapDetailsCardState extends State<ZwapDetailsCard>{

  bool _isHover = false;

  void _handleHover(bool isHovered){
    setState(() {
      this._isHover = isHovered;
    });
  }

  /// It gets the text info inside this card
  Widget _getTextInfo(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: ZwapText(
            text: widget.title,
            zwapTextType: ZwapTextType.h4,
            textColor: widget.isSelected ? ZwapColors.shades0 : ZwapColors.neutral800,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 25),
          child: widget.subTitle,
        ),
      ],
    );
  }

  /// It gets the final child for this card
  Widget _getChildWidget(){
    return widget.imagePath != null ?
    Row(
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 4),
            child: ZwapAvatar(
              imagePath: widget.imagePath!,
              isExternal: widget.isExternalImage,
            ),
          ),
          flex: 0,
          fit: FlexFit.tight,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 4),
            child: this._getTextInfo(),
          ),
          fit: FlexFit.tight,
          flex: 0,
        )
      ],
    ) : this._getTextInfo();
  }

  Widget build(BuildContext context){
    return MouseRegion(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: widget.isSelected ? ZwapColors.primary700 : (this._isHover ? ZwapColors.neutral100 : ZwapColors.shades0),
            borderRadius: BorderRadius.all(Radius.circular(ZwapRadius.buttonRadius)),
            border: Border.all(
                color: widget.isSelected ? ZwapColors.primary700 : (this._isHover ? ZwapColors.neutral100 : ZwapColors.shades0),
                width: 1
            )
        ),
        child: this._getChildWidget(),
      ),
      onHover: (_) => this._handleHover(true),
      onExit: (_) => this._handleHover(false),
    );
  }
}