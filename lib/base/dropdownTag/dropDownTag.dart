/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:taastrap/colStrap/colStrap.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The state of this custom dropdown element
class DropDownTagState extends ChangeNotifier{

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

/// Custom widget to display dropdown with tag inside
class DropDownTag extends StatelessWidget{

  /// The values inside the dropdown list
  final List<String> values;

  DropDownTag({Key? key,
    required this.values,
  }): super(key: key);

  Map<Widget, Map<String, int>> _getResponsiveChildren(DropDownTagState value){
    Map<Widget, Map<String, int>> finals = {};
    value.values.forEach((element) {
      Widget tmp = TagElement(
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
    return ProviderCustomer<DropDownTagState>(
      elementChild: (Consumer<DropDownTagState> consumer){
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: CustomDropDown(
                  values: this.values,
                  handleChange: (String value) => Provider.of<DropDownTagState>(context, listen: false).changeValues(value, true)
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: consumer,
            )
          ],
        );
      },
      childWidget: (DropDownTagState value) => ResponsiveRow(
        children: this._getResponsiveChildren(value),
      ),
    );
  }



}