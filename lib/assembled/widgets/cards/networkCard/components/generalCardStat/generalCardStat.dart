import 'package:flutter/cupertino.dart';
import 'package:zwap_design_system/base/base.dart';

import 'package:zwap_design_system/zwap_design_system.dart';

enum GeneralStatType{
 TagStat,
 TagText
}

class GeneralCardStat extends StatelessWidget{

  final String title;

  final String stat;

  final GeneralStatType cardType;

  GeneralCardStat({Key? key,
    required this.title,
    required this.stat,
    required this.cardType
  }): super(key: key);

  Widget _getRightElement(){
    switch(this.cardType){
      case GeneralStatType.TagStat:
        return TagElement(tagText: this.stat, tagStyleType: TagStyleType.pinkyTag,);
      case GeneralStatType.TagText:
        return BaseText(
          texts: [this.stat],
          baseTextsType: [BaseTextType.normalBold],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DesignColors.scaffoldColor,
        borderRadius: BorderRadius.circular(ConstantsValue.radiusValue)
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Flexible(
                child: Row(
                  children: [
                    Flexible(
                      child: BaseText(
                        texts: [this.title],
                        baseTextsType: [BaseTextType.normal],
                      ),
                      flex: 0,
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: this._getRightElement(),
                      ),
                      flex: 0,
                    ),
                  ],
                )
            ),
            Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: BaseText(
                        texts: ["Vedi dettagli"],
                        baseTextsType: [BaseTextType.normalBold],
                        textsColor: [DesignColors.blueButton],
                      ),
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }



}