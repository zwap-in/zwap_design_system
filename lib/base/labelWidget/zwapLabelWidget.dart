/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/text/zwapText.dart';
import 'package:zwap_design_system/base/theme/theme.dart';

/// Base widget to display a custom widget with a title and optionally a subTitle bottom on the title
class ZwapLabelWidget extends StatelessWidget {

  /// The text of the label title
  final String labelText;

  /// The widget child inside this component
  final Widget childComponent;

  /// The text of the optionally label subTitle
  final String? labelSubText;

  /// The padding inside this column
  final EdgeInsets? paddingInside;

  ZwapLabelWidget({Key? key,
    required this.labelText,
    required this.childComponent,
    this.paddingInside,
    this.labelSubText,
  }): super(key: key);


  /// It Retrieves title and optionally subtitle label
  List<Widget> _getChildrenComponents(){
    List<Widget> childrenComponents = [];
    ZwapText tmp = ZwapText(
      texts: [this.labelText],
      baseTextsType: [ZwapTextType.normalBold],
    );
    childrenComponents.add(
      this.paddingInside != null ?
          Padding(
            padding: this.paddingInside!,
            child: tmp,
          ) : tmp
    );
    if(this.labelSubText != null){
      ZwapText tmp = ZwapText(
        texts: [this.labelSubText!],
        textsColor: [DesignColors.greyPrimary],
        baseTextsType: [ZwapTextType.subTitle],
      );
      childrenComponents.add(
          this.paddingInside != null ? Padding(
            padding: this.paddingInside!,
            child: tmp,
          ) : tmp
      );
    }
    return childrenComponents;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: this._getChildrenComponents(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: this.childComponent,
        )
      ],
    );
  }
}
