/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

/// The card for the dropDown menu
class ZwapDropDownMenu extends StatelessWidget{

  /// The items for this menu
  final Map<String, TupleType<IconData, Function(String menuItem)>> menuItems;

  ZwapDropDownMenu({Key? key,
    required this.menuItems
  }): super(key: key);

  Widget build(BuildContext context){
    List<String> keys = this.menuItems.keys.toList();
    return ZwapCard(
      zwapCardType: ZwapCardType.levelOne,
      child: Column(
        children: List<Widget>.generate(keys.length, (index) =>
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: () => this.menuItems[keys[index]]!.b,
                child: Row(
                  children: [
                    Flexible(
                      flex: 0,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(
                          this.menuItems[keys[index]]!.a,
                          size: 1,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 0,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: ZwapText(
                          text: keys[index],
                          textColor: ZwapColors.neutral700,
                          zwapTextType: ZwapTextType.body1Regular,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }


}