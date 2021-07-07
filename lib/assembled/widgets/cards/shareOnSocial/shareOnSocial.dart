import 'package:flutter/cupertino.dart';

import 'package:zwap_design_system/zwap_design_system.dart';

class ShareOnSocial extends StatelessWidget{

  final String socialText;

  ShareOnSocial({Key? key,
    required this.socialText
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      childComponent: Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            BaseText(
              texts: [""],
              baseTextsType: [BaseTextType.title],
            ),
            Row(
              children: [
                Flexible(
                  child: Column(
                    children: [
                      CustomAsset(assetPathUrl: "", isInternal: true,),
                      CustomAsset(assetPathUrl: "", isInternal: true,),
                      CustomAsset(assetPathUrl: "", isInternal: true,),
                    ],
                  ),
                  flex: 1,
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                       color: DesignColors.blackPrimary,
                       width: 1
                      )
                    ),
                    child: BaseText(
                      texts: [this.socialText],
                      baseTextsType: [BaseTextType.normal],
                      textsColor: [DesignColors.greyPrimary],
                    ),
                  ),
                  flex: 1,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }


}