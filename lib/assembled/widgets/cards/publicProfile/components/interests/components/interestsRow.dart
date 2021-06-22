/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';


/// Custom widget to show the interests inside a responsive row
class InterestsRow extends StatelessWidget{

  /// The interests list to display inside this row custom widget
  final List<String> interestsList;

  InterestsRow({Key? key,
    required this.interestsList
  }): super(key: key);

  /// It builds the responsive row for interests to show
  Map<Widget, Map<String, int>> _responsivePartitionInterests(){
    Map<Widget, Map<String, int>> finals = {};
    this.interestsList.forEach((String element) {
      Widget tmp = Padding(
        padding: EdgeInsets.all(5),
        child: TagElement(
          tagText: element,
        ),
      );
      finals[tmp] = {'xl': 3, 'lg': 3, 'md': 4, 'sm': 6, 'xs': 6};
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveRow(
      children: this._responsivePartitionInterests(),
    );
  }

}