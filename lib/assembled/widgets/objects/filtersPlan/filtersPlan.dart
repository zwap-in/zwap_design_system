/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The provider to handle the state inside this custom filters widget
class FiltersProvider extends ChangeNotifier{

  /// The value mapping
  Map<String, dynamic> mappingValues = {};

  /// Handling changing value
  void changeMappingValue(String key, dynamic value){
    this.mappingValues[key] = value;
    notifyListeners();
  }

}

/// Custom component to create a collapse widget to show inside the custom filters
class FiltersPlan extends StatelessWidget{

  /// The dynamic filters list
  final List<NetworkFilterElement> filters;

  FiltersPlan({Key? key,
    required this.filters,
  }): super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: BaseText(
          texts: [Utils.translatedText("chooseYourMatchTitle")],
          baseTextsType: [BaseTextType.title],
        ),
      children: [
        VerticalScroll(
            childComponent: Column(
              children: [
                for(int i = 0; i < this.filters.length; i++) Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: LineSettings(
                      title: Utils.translatedText(this.filters[i].networkTitle),
                      subTitle: Utils.translatedText(this.filters[i].networkSubTitle),
                      rightElement: Consumer<FiltersProvider>(
                        builder: (builder, provider, child){
                          return NetworkFilter(
                            currentValue: provider.mappingValues[this.filters[i].filterKeyName],
                            changeValueCallBack: (String value) => provider.changeMappingValue(this.filters[i].filterKeyName, value),
                            networkFilter: this.filters[i],
                          );
                        }
                      )
                    ),
                  )
              ],
          )
        )
      ],
    );
  }
  
  
  
  
}