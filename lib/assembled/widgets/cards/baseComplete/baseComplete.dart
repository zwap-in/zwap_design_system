/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The Base complete card
class BaseComplete extends StatelessWidget{

  /// The children widget inside this column
  final List<Widget> childrenWidget;

  /// The back button callBack function
  final Function() backButtonCallBack;

  /// The continue button callBack function
  final Function() continueButtonCallBack;

  BaseComplete({Key? key,
    required this.childrenWidget,
    required this.backButtonCallBack,
    required this.continueButtonCallBack
  }): super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Widget> _children = this.childrenWidget;
    _children.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: BottomButtons(
            backButtonText: LocalizationClass.of(context).dynamicValue("backButton"),
            continueButtonText: LocalizationClass.of(context).dynamicValue("continueButton"),
            backButtonCallBackFunction: () => this.backButtonCallBack(),
            continueButtonCallBackFunction: () => this.continueButtonCallBack(),
          ),
        )
    );

    return CustomCard(
      childComponent: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: _children,
        ),
      ),
    );
  }


}