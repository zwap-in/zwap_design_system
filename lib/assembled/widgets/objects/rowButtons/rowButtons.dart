import 'package:flutter/cupertino.dart';

import 'package:zwap_design_system/zwap_design_system.dart';

/// The row buttons widget to display two side buttons
class RowButtons extends StatelessWidget{

  /// The selected button
  final int selected;

  /// CallBack to change the selected button on selected click
  final Function(int selected) changeSelectedButton;

  RowButtons({Key? key,
    required this.selected,
    required this.changeSelectedButton
  }): super(key: key){
    assert(this.selected >= 0 && this.selected < 2, "selected value must be 0 or 1");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: BaseButton(
              buttonTypeStyle: this.selected == 0 ? ButtonTypeStyle.pinkyButton : ButtonTypeStyle.greyButton,
              buttonText: Utils.translatedText("oneToOneMeeting"),
              onPressedCallback: () => this.changeSelectedButton(0),
            ),
          flex: 0,
        ),
        Flexible(
          child: BaseButton(
            buttonTypeStyle: this.selected == 1 ? ButtonTypeStyle.pinkyButton : ButtonTypeStyle.greyButton,
            buttonText: Utils.translatedText("groupsMeeting"),
            onPressedCallback: () => this.changeSelectedButton(1),
          ),
          flex: 0,
        )
      ],
    );
  }



}