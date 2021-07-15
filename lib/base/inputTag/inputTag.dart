/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:taastrap/colStrap/colStrap.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Class to manage the state inside the InputTag component
class InputTagState extends ChangeNotifier{

  /// The values to display inside the responsive row
  final List<String> inputValues = [];

  /// Function to change the values
  void changeValues(String value, bool check){
    if(check){
      this.inputValues.add(value);
    }
    else{
      int index = this.inputValues.indexOf(value);
      this.inputValues.removeAt(index);
    }
    notifyListeners();
  }

  List<String> get getValues => this.inputValues;

}

/// Custom widget to display a base input with on top a responsive row with element tag
class InputTag extends StatelessWidget{

  /// It retrieves the children in a responsive way
  Map<Widget, Map<String, int>> childrenResponsive(InputTagState value){
    Map<Widget, Map<String, int>> finals = {};
    value.inputValues.asMap().forEach((int index, String element) {
      Widget tmp = Padding(
        padding: index == 0 ? EdgeInsets.only(right: 10, bottom: 10) : EdgeInsets.only(right: 10, left: 10, bottom: 10),
        child: TagElement(
          tagText: element,
          icon: IconData(0),
          callBackClick: () => value.changeValues(element, false),
        ),
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
          padding: EdgeInsets.only(bottom: 20),
          child: Consumer<InputTagState>(
              builder: (context, provider, child){
                return ResponsiveRow(
                  children: this.childrenResponsive(provider),
                );
              }
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: BaseInput(
            validateValue: (value) { return true; },
            inputType: InputType.inputText,
            changeValue: (dynamic value) => context.read<InputTagState>().changeValues(value, true),
            placeholderText: '',
          ),
        )
      ],
    );
  }

}