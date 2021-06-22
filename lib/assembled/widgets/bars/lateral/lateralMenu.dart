/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  final List<String> listMenu;

  /// The initial selected item for the lateral menu
  final String? initialItem;

  /// The provider to handle the state
  final LateralMenuState provider;

  LateralMenu({Key? key,
    required this.listMenu,
    required this.provider,
    this.initialItem
  }): super(key: key);

  /// It displays inside the column of the lateral menu
  List<Widget> _items(){
    List<Widget> finals = [];
    String _tmp = this.provider.current != "" ? this.provider.current : this.listMenu.first;
    this.listMenu.forEach((String value) {
      finals.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: BaseText(
              texts: [value],
              textsColor: [value == _tmp ? DesignColors.bluePrimary : DesignColors.greyPrimary],
              baseTextsType: [BaseTextType.title],
              hasClick: [true],
              callBacksClick: [() => this.provider.changeCurrentSelected(value)],
            ),
          )
      );
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: this._items(),
    );
  }

}
