/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/design/colors.dart';
import 'package:zwap_design_system/design/text.dart';
import 'package:zwap_design_system/texts/baseText/baseText.dart';

/// Custom base widget to display a label with title and optionally subtitle with custom widget
class LabelWidget extends StatelessWidget {

  /// The text of the label title
  final String labelText;

  /// The text of the label subTitle. Default = ""
  final String labelSubText;

  /// The widget child with the label text
  final Widget childComponent;

  /// The Alignment on the axis of this column. Default = CrossAxisAlignment.start
  final CrossAxisAlignment axisAlignment;

  /// The padding inside the container. Default = const EdgeInset.all(5)
  final EdgeInsets paddingContainer;

  /// The padding between the widgets. Default = const EdgeInsets.only(bottom: 10)
  final EdgeInsets paddingBetweenWidgets;

  /// The color of the text title. Default = DesignColors.blackPrimary
  final Color colorTitle;

  /// The color of the text subTitle. Default = DesignColors.greyPrimary
  final Color colorSubTitle;

  /// The fontSize of the title. Default = 13
  final double fontSizeTitle;

  /// The fontSize of the subTitle. Default = 10
  final double fontSizeSubTitle;


  LabelWidget({Key? key,
    required this.labelText,
    required this.childComponent,
    this.labelSubText = "",
    this.axisAlignment = CrossAxisAlignment.start,
    this.paddingContainer = const EdgeInsets.all(5),
    this.colorTitle = DesignColors.blackPrimary,
    this.colorSubTitle = DesignColors.greyPrimary,
    this.fontSizeTitle = 13,
    this.fontSizeSubTitle = 10,
    this.paddingBetweenWidgets = const EdgeInsets.only(bottom: 10)
  }): super(key: key);


  /// Retrieve title and subtitle label for this children widget
  List<Widget> _getChildrenComponents(){

    TextStyle titleLabelText = TextDesign.defaultNormalTextStyle.apply(fontSizeDelta: this.fontSizeTitle, color: this.colorTitle);

    TextStyle subTitleLabelText = TextDesign.defaultNormalTextStyle.apply(fontSizeDelta: this.fontSizeSubTitle, color: this.colorSubTitle);

    List<Widget> childrenComponents = [];
    childrenComponents.add(
      BaseText(text: this.labelText,
          alignment: Alignment.topLeft,
          textAlign: TextAlign.left,
          paddingContainer: EdgeInsets.zero,
          textStyle: titleLabelText),
    );
    if(this.labelSubText != ""){
      childrenComponents.add(BaseText(text: this.labelSubText,
          alignment: Alignment.topLeft,
          textAlign: TextAlign.left,
          paddingContainer: EdgeInsets.zero,
          textStyle: subTitleLabelText));
    }
    return childrenComponents;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.paddingContainer,
      child: Column(
        crossAxisAlignment: this.axisAlignment,
        children: [
          Padding(
            padding: this.paddingBetweenWidgets,
            child: Column(
              crossAxisAlignment: this.axisAlignment,
              children: this._getChildrenComponents(),
            ),
          ),
          this.childComponent
        ],
      ),
    );
  }
}
