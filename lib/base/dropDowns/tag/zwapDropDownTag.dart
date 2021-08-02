/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:taastrap/colStrap/colStrap.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/tag/zwapTag.dart';

import '../classic/zwapDropDown.dart';

/// The state of this custom dropdown element
class ZwapDropDownTagState extends ChangeNotifier{

  /// The values state
  final List<String> values = [];

  /// Changing values
  void changeValues(String value, bool isAdd){
    if(isAdd){
      this.values.add(value);
    }
    else{
      int index = this.values.indexOf(value);
      this.values.removeAt(index);
    }
    notifyListeners();
  }

}

/// Extend dropDownState
class ZwapDropDownStateExtended extends ZwapDropDownState{

  final ZwapDropDownTagState provider;

  ZwapDropDownStateExtended({required this.provider});

  void onChangeValue (String? value){
    super.onChangeValue(value);
    this.provider.changeValues(value!, true);
  }

}

/// Custom widget to display dropdown with tag inside
class ZwapDropDownTag extends StatelessWidget{

  /// The values inside the dropdown list
  final List<String> values;

  ZwapDropDownTag({Key? key,
    required this.values,
  }): super(key: key);

  /// It retrieves the row with the custom tags inside it in a responsive way
  Map<Widget, Map<String, int>> _getResponsiveChildren(ZwapDropDownTagState value){
    Map<Widget, Map<String, int>> finals = {};
    value.values.forEach((element) {
      Widget tmp = ZwapTag(
        tagText: element,
        icon: IconData(0),
        callBackClick: () => value.changeValues(element, false),
      );
      finals[tmp] = {'xl': 3, 'lg': 3, 'md': 4, 'sm': 6, 'xs': 6};
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ChangeNotifierProvider<ZwapDropDownStateExtended>(
              create: (_) => ZwapDropDownStateExtended(provider: context.read<ZwapDropDownTagState>()),
              builder: (builder, child){
                return ZwapDropDown(
                  values: this.values,
                );
              }
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Consumer<ZwapDropDownTagState>(
            builder: (builder, provider, child){
              return ResponsiveRow(
                children: this._getResponsiveChildren(provider),
              );
            }
          ),
        )
      ],
    );
  }



}