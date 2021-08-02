/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/theme/theme.dart';
import 'package:zwap_design_system/base/text/zwapText.dart';


/// This is a component to render a custom setting inline
class ZwapLineSettings extends StatelessWidget{

  /// The title of the line
  final String title;

  /// The subtitle of the line
  final String? subTitle;

  /// The widget element inside this line settings
  final Widget rightElement;

  ZwapLineSettings({Key? key,
    required this.title,
    required this.subTitle,
    required this.rightElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 4, top: 0),
                    child: ZwapText(
                      texts: [this.title],
                      baseTextsType: [ZwapTextType.normalBold],
                    ),
                  ),
                  this.subTitle != null ?
                  Padding(
                    padding: EdgeInsets.only(bottom: 4, top: 4),
                    child: ZwapText(
                      texts: [this.subTitle!],
                      baseTextsType: [ZwapTextType.subTitle],
                      textsColor: [DesignColors.greyPrimary],
                    ),
                  ) : Container(),
                ],
              ),
            ),
          ),
          Flexible(child: this.rightElement)
        ],
      ),
    );
  }

}