/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:taastrap/colStrap/colStrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

import '../baseStat/baseStat.dart';

class BaseStateType{

  final String baseStatTitle;

  final String baseStatNumber;

  final String baseStatGraphImage;

  BaseStateType({
    required this.baseStatTitle,
    required this.baseStatNumber,
    required this.baseStatGraphImage
  });

}

class HeaderNetwork extends StatelessWidget{

  final String firstName;

  final String lastName;

  final List<BaseStateType> baseStateType;

  HeaderNetwork({Key? key,
    required this.firstName,
    required this.lastName,
    required this.baseStateType
  }): super(key: key);

  Map<Widget, Map<String, int>> _getStatColumns(){
    Map<Widget, Map<String, int>> finals = {};
    this.baseStateType.forEach((element) {
      Widget tmp = BaseStat(title: element.baseStatTitle, numberStat: element.baseStatNumber, graphImage: element.baseStatGraphImage);
      finals[tmp] = {'xl': 3, 'lg': 3, 'md': 4, 'sm': 6, 'xs': 6};
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: AvatarCircle(imagePath: ""),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: BaseText(
                    texts: ["${this.firstName} ${this.lastName}"],
                    baseTextsType: [BaseTextType.title],
                  ),
                )
              ],
            ),
          ),
          flex: 0,
        ),
        Flexible(
            child: Container(
              child: ResponsiveRow(
                children: this._getStatColumns(),
              ),
            )
        )
      ],
    );
  }

}