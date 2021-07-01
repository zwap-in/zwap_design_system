/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:taastrap/taastrap.dart';

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
    int _deviceType = DeviceInherit.of(context).deviceType;
    List<Widget> _children = this.childrenWidget;
    if(_deviceType > 2){
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
    }

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