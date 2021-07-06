/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The filters widget to display inside the network card
class Filters extends StatelessWidget{

  /// CallBack function to search any contacts inside the network card
  final Function(String searchText) searchCallBack;

  /// Importing contacts callBack
  final Function() importContactsCallBack;

  /// Show filters callBack
  final Function() showFiltersCallBack;

  /// Exporting contacts callBack
  final Function() exportContactsCallBack;

  Filters({Key? key,
    required this.searchCallBack,
    required this.importContactsCallBack,
    required this.showFiltersCallBack,
    required this.exportContactsCallBack
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: BaseInput(
              validateValue: (value) { return true; },
              inputType: InputType.inputSearch,
              placeholderText: Utils.translatedText("searchFiltersPlaceholder"),
              changeValue: (value) => this.searchCallBack(value),
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
                      buttonText: Utils.translatedText("importContactsButton"),
                      buttonTypeStyle: ButtonTypeStyle.pinkyButton,
                      onPressedCallback: () => this.importContactsCallBack(),
                    ),
                  ),
                  flex: 1,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: BaseButton(
                      iconButton: Icons.group_add,
                      buttonText: Utils.translatedText("exportContactsButton"),
                      buttonTypeStyle: ButtonTypeStyle.pinkyButton,
                      onPressedCallback: () => this.exportContactsCallBack(),
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