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
    if(check && value.contains(" ")){
      this.inputValues.add(value.split(" ")[0]);
      Utils.getIt<BaseInputState>().controller.clear();
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
        padding: EdgeInsets.all(10),
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
    return ChangeNotifierProvider(
        create: (_) => BaseInputState(handleValidation: (dynamic value) => true,  controller: TextEditingController()),
        builder: (builder, child){
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
                child: Consumer<BaseInputState>(
                    builder: (builder, provider, child){
                      return BaseInput(
                        validateValue: (value) { return true; },
                        inputType: InputType.inputText,
                        changeValue: (dynamic value) => value != "" ? context.read<InputTagState>().changeValues(value, true) : {},
                        placeholderText: '',
                      );
                    }
                ),
              )
            ],
          );
      }
    );
  }

}