/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:taastrap/colStrap/colStrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Custom widget to create the responsive row to display targets inside this card component
class TargetsRow extends StatelessWidget{

  /// The targets mapping info
  final Map<String, Map<String, dynamic>> targetsMappingInfo;

  TargetsRow({Key? key,
    required this.targetsMappingInfo
  }): super(key: key);

  /// It builds the responsive row of the targets
  Map<Widget, Map<String, int>> _responsePartitionTargets(){
    Map<Widget, Map<String, int>> finals = {};
    this.targetsMappingInfo.forEach((String key, Map<String, dynamic> value) {
      Widget tmp = ImageCard(
          textCard: key,
          imagePath: value['imagePath']!,
          isInternalAsset: value['internalInfo']!
      );
      finals[tmp] = {'xl': 3, 'lg': 3, 'md': 4, 'sm': 6, 'xs': 6};
    });
    return finals;
  }


  @override
  Widget build(BuildContext context) {
    return ResponsiveRow(
      children: this._responsePartitionTargets(),
    );
  }
  
}