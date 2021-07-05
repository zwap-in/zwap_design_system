/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// A change notifier to handle the state inside the lateral menu
class LateralMenuState extends ChangeNotifier{

  /// The current selected value
  String _currentSelected = "";

  /// The callBack to set the selected item
  void changeCurrentSelected(String item){
    _currentSelected = item;
    notifyListeners();
  }

  /// It retrieves the current selected element
  String get current => _currentSelected;
}


/// The lateral menu to filter some options
class LateralMenu extends StatelessWidget{

  /// The list menu
  final Map<String, String> listMenu;

  /// The initial selected item for the lateral menu
  final String? initialItem;

  LateralMenu({Key? key,
    required this.listMenu,
    this.initialItem
  }): super(key: key);

  /// It displays inside the column of the lateral menu
  List<Widget> _items(LateralMenuState provider){
    List<Widget> finals = [];
    String _tmp = provider.current != "" ? provider.current : this.listMenu.keys.first;
    this.listMenu.forEach((String key, String value) {
      finals.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: BaseText(
              texts: [Utils.getIt<LocalizationClass>().dynamicValue(key)],
              textsColor: [value == _tmp ? DesignColors.bluePrimary : DesignColors.greyPrimary],
              baseTextsType: [BaseTextType.title],
              hasClick: [true],
              callBacksClick: [() => provider.changeCurrentSelected(value)],
            ),
          )
      );
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LateralMenuState>(
      builder: (builder, provider, child){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: this._items(provider),
        );
      },
    );
  }

}
