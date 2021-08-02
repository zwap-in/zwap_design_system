/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:taastrap/colStrap/colStrap.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/tag/zwapTag.dart';

import '../classic/zwapInput.dart';
import '../suggestion/zwapInputSuggestion.dart';

/// The type of the input tag type
enum ZwapInputTagType{
  suggestion,
  classic
}

/// Class to manage the state inside the InputTag component
class ZwapInputTagState extends ChangeNotifier{

  /// The values to display inside the responsive row
  final List<String> inputValues = [];

  /// Function to change the values
  void changeValues(String value, bool check, TextEditingController controller){
    if(check){
      if(value.contains(" ")){
        this.inputValues.add(value.split(" ")[0]);
        controller.clear();
      }
    }
    else{
      int index = this.inputValues.indexOf(value);
      this.inputValues.removeAt(index);
    }
    notifyListeners();
  }

  /// It retrieves the values from the list of input tags
  List<String> get getValues => this.inputValues;

}

/// Custom widget to display a base input with on top a responsive row with element tag
class ZwapInputTag extends StatelessWidget{

  /// Custom type in base of the current input tag type
  final ZwapInputTagType inputTagType;

  ZwapInputTag({Key? key,
    required this.inputTagType
  }): super(key: key);

  /// It retrieves the children in a responsive way
  Map<Widget, Map<String, int>> childrenResponsive(ZwapInputTagState value, TextEditingController controller){
    Map<Widget, Map<String, int>> finals = {};
    value.inputValues.asMap().forEach((int index, String element) {
      Widget tmp = Padding(
        padding: EdgeInsets.all(10),
        child: ZwapTag(
          tagText: element,
          icon: IconData(0),
          callBackClick: () => value.changeValues(element, false, controller),
        ),
      );
      finals[tmp] = {'xl': 3, 'lg': 3, 'md': 4, 'sm': 6, 'xs': 6};
    });
    return finals;
  }

  Widget plotInput(TextEditingController controller){
    if(this.inputTagType == ZwapInputTagType.classic){
      return ZwapInput(
        inputType: ZwapInputType.inputText,
        placeholderText: '',
        controller: controller,
      );
    }
    else{
      return ZwapInputSuggestion(
          suggestion: [],
          controller: controller
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    controller.addListener(() {
      context.read<ZwapInputTagState>().changeValues(controller.text, true, controller);
    });
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Consumer<ZwapInputTagState>(
              builder: (context, provider, child){
                return ResponsiveRow(
                  children: this.childrenResponsive(provider, controller),
                );
              }
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: this.plotInput(controller),
        )
      ],
    );
  }

}