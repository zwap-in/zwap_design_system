import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:zwap_design_system/zwap_design_system.dart';

class FiltersProvider extends ChangeNotifier{

  String currentNetwork = "";

  String kindOfMeeting = "";

  void changeNetwork(String network){
    this.currentNetwork = network;
    notifyListeners();
  }

  void changeKindOfMeeting(String newKind){
    this.kindOfMeeting = newKind;
    notifyListeners();
  }

}



class FiltersPlan extends StatelessWidget{

  final List<String> networksList;

  FiltersPlan({Key? key,
    required this.networksList,
  }): super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: BaseText(
          texts: [Utils.translatedText("chooseYourMatchTitle")],
          baseTextsType: [BaseTextType.title],
        ),
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: LineSettings(
                  title: Utils.translatedText("chooseYourNetwork"),
                  subTitle: Utils.translatedText("chooseYourNetworkSubTitle"),
                  rightElement: Consumer<FiltersProvider>(
                    builder: (builder, provider, child){
                      return CustomDropDown(
                        values: this.networksList,
                        handleChange: (String value) => provider.changeNetwork(value),
                      );
                    }
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: LineSettings(
                  title: Utils.translatedText("kindOfMeetingTitle"),
                  subTitle: Utils.translatedText("kindOfMeetingSubTitle"),
                  rightElement: Consumer<FiltersProvider>(
                      builder: (builder, provider, child){
                        return RowButtons(
                          selected: provider.kindOfMeeting == "1:1" ? 0 : 1,
                          changeSelectedButton: (int newSelection) => provider.changeKindOfMeeting(newSelection == 0 ? "1:1" : "groups"),
                        );
                      }
                  )
              ),
            ),
          ],
        )
      ],
    );
  }
  
  
  
  
}