/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES COMPONENTS
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

/// The dropdown for the popup menu
class ZwapPopupMenu extends StatelessWidget{

  /// The menu items to display inside the dropdown menu
  final Map<String, TupleType<String, Function()>> menuItems;

  ZwapPopupMenu({Key? key,
    required this.menuItems
  }): super(key: key);

  Widget build(BuildContext context){
    return ZwapCard(
      cardWidth: 300,
      zwapCardType: ZwapCardType.levelZero,
      child: Column(
        children: List<Widget>.generate(this.menuItems.keys.toList().length, (int index) => Padding(
          child: InkWell(
            onTap: () => this.menuItems[this.menuItems.keys.toList()[index]]!.b(),
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 0,
                  child: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: ZwapIcons.icons(this.menuItems[this.menuItems.keys.toList()[index]]!.a)
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: ZwapText(
                      zwapTextType: ZwapTextType.body1Regular,
                      text: this.menuItems.keys.toList()[index],
                      textColor: ZwapColors.neutral700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        )),
      ),
    );
  }

}