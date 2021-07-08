/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zwap_design_system/zwap_design_system.dart';

/// Custom component to show some item in a checklist
class CheckListItem extends StatelessWidget {

  /// The checklist item text
  final String checkListItemText;

  /// Is the item done?
  final bool isDoneItem;

  final Function() callBackClick;

  CheckListItem({Key? key,
    required this.checkListItemText,
    required this.isDoneItem,
    required this.callBackClick
  }): super(key: key);


  @override
  Widget build(BuildContext context) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 10),
            child: CustomCheckbox(isDone: this.isDoneItem,),
          ),
          flex: 0,
        ),
        new Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: BaseText(
              texts: [this.checkListItemText],
              baseTextsType: [BaseTextType.normalBold],
              hasClick: [true],
              callBacksClick: [() => this.callBackClick()],
              textsColor: [this.isDoneItem ? DesignColors.greenPrimary : DesignColors.greyPrimary],
            ),
          ),
        ),
      ],
    );
  }
}
