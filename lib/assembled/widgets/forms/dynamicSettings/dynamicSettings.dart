/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// This is a component to render a custom icon with a png asset
class LineSettings extends StatelessWidget{

  /// The title of the line
  final String title;

  /// The subtitle of the line
  final String? subTitle;

  /// The widget element inside this line settings
  final Widget rightElement;

  LineSettings({Key? key,
    required this.title,
    required this.subTitle,
    required this.rightElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 4, top: 0),
                    child: BaseText(
                      texts: [this.title],
                      baseTextsType: [BaseTextType.normalBold],
                    ),
                  ),
                  this.subTitle != null ?
                  Padding(
                    padding: EdgeInsets.only(bottom: 4, top: 4),
                    child: BaseText(
                      texts: [this.subTitle!],
                      baseTextsType: [BaseTextType.subTitle],
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