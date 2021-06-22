/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:taastrap/colStrap/colStrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Show badges inside a row in a responsive way
class BadgesRow extends StatelessWidget{

  /// The badges mapping info
  final Map<String, Map<String, dynamic>> badgesMappingInfo;

  BadgesRow({Key? key,
    required this.badgesMappingInfo
  }): super(key: key);

  Widget _getBadgeChild(String imagePath, bool isInternal){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: AvatarCircle(
          imagePath: imagePath,
      ),
    );
  }

  /// It returns all badges inside a row to display inside the profile card widget
  ResponsiveRow _responsePartitionBadges(){
    Map<Widget, Map<String, int>> children = {};
    this.badgesMappingInfo.forEach((String key, Map<String, dynamic> value) {
      Widget baseChild = this._getBadgeChild(value['imagePath'], value['internalInfo']);
      children[baseChild] = {'xl': 3, 'lg': 3, 'md': 4, 'sm': 4, 'xs': 4};
    });
    return ResponsiveRow(
        children: children,
    );
  }


  @override
  Widget build(BuildContext context) {
    return this._responsePartitionBadges();
  }

}