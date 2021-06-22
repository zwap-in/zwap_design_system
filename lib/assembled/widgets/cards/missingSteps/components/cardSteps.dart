/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zwap_design_system/base/layouts/verticalScroll/verticalScroll.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

import 'checkListItem.dart';

/// Custom widget to show the missing steps
class CardSteps extends StatelessWidget {

  /// The title of the card steps
  final String titleCard;

  /// The mapping info about the checkList elements
  final Map<String, bool> mappingListElements;

  CardSteps({Key? key,
    required this.titleCard,
    required this.mappingListElements,
  }): super(key: key);

  /// It retrieve the missing steps to show inside this card with the check list item
  List<Widget> _missedSteps(){
    List<Widget> finals = [];
    for ( var i in this.mappingListElements.keys )
      finals.add(Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: CheckListItem(
            checkListItemText: i,
            isDoneItem: this.mappingListElements[i]!),
      ));
    return finals;
  }

  @override
  Widget build(BuildContext context) {

    return new CustomCard(
        cardWidth: 319,
        cardHeight: 200,
        childComponent: Padding(
            padding: EdgeInsets.all(20),
            child: VerticalScroll(
                childComponent: Column(
                    children: [
                      Row(
                        children: [
                          new Expanded(
                            child: BaseText(
                              texts: [this.titleCard],
                              baseTextsType: [BaseTextType.title],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 10, top: 10
                        ),
                        child: Column(
                          children: this._missedSteps(),
                        ),
                      )
                    ],
                ),
            ),
        )
    );
  }
}
