/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/theme/theme.dart';
import 'package:zwap_design_system/base/text/zwapText.dart';

/// A change notifier to handle the state inside the lateral menu
class ZwapLateralMenuState extends ChangeNotifier{

  /// The current selected value
  String current;

  /// callBack function to handle change items
  final Function(String selectedFilter) changeCallBack;

  ZwapLateralMenuState({required this.changeCallBack, required this.current});

  /// The callBack to set the selected item
  void changeCurrentSelected(String item){
    this.current = item;
    this.changeCallBack(item);
    notifyListeners();
  }
}


/// The lateral menu to filter some options
class ZwapLateralMenu extends StatelessWidget{

  /// The list menu
  final List<String> listMenu;

  /// The initial selected item for the lateral menu
  final String? initialItem;

  final Function(String key) getCorrectText;

  ZwapLateralMenu({Key? key,
    required this.listMenu,
    required this.getCorrectText,
    this.initialItem
  }): super(key: key);

  /// It lists all the items inside the column list
  List<Widget> _items(ZwapLateralMenuState provider){
    List<Widget> finals = [];
    String _tmp = provider.current != "" ? provider.current : this.listMenu.first;
    this.listMenu.forEach((String element) {
      finals.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ZwapText(
              texts: [this.getCorrectText(element)],
              textsColor: [element == _tmp ? DesignColors.bluePrimary : DesignColors.greyPrimary],
              baseTextsType: [ZwapTextType.title],
              hasClick: [true],
              callBacksClick: [() => provider.changeCurrentSelected(element)],
            ),
          )
      );
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ZwapLateralMenuState>(
      builder: (builder, provider, child){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: this._items(provider),
        );
      },
    );
  }

}
