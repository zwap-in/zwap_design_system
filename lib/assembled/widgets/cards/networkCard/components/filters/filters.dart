/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

class Filters extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: BaseInput(
              validateValue: (value) { return true; },
              inputType: InputType.inputSearch,
              placeholderText: 'Cerca per nome, città, settore, ruolo',
              changeValue: (value) {  },
            ),
          flex: 1,
        ),
        Flexible(
          child: Container(),
          flex: 1,
        ),
        Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: BaseButton(
                      iconButton: Icons.group_add,
                      buttonText: "Importa contatti",
                      buttonTypeStyle: ButtonTypeStyle.pinkyButton,
                      onPressedCallback: (){},
                    ),
                  ),
                  flex: 1,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: BaseButton(
                      iconButton: Icons.group_add,
                      buttonText: "Mostra filtri",
                      buttonTypeStyle: ButtonTypeStyle.pinkyButton,
                      onPressedCallback: (){},
                    ),
                  ),
                  flex: 1,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: BaseButton(
                      iconButton: Icons.group_add,
                      buttonText: "Esporta",
                      buttonTypeStyle: ButtonTypeStyle.pinkyButton,
                      onPressedCallback: (){},
                    ),
                  ),
                  flex: 1,
                ),
              ],
            ),
          flex: 2,
        )
      ],
    );
  }



}