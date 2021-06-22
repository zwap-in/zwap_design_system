/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

import 'components/components.dart';


/// Custom widget to display the network card
class NetworkCard extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      cardWidth: 1200,
      childComponent: VerticalScroll(
        childComponent: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  HeaderNetwork(firstName: "Federico", lastName: "Chiesa", baseStateType: [
                    BaseStateType(baseStatTitle: "Meeting totale", baseStatNumber: "13", baseStatGraphImage: "assets/images/assets/contact.png"),
                    BaseStateType(baseStatTitle: "Meeting totale", baseStatNumber: "13", baseStatGraphImage: "assets/images/assets/contact.png"),
                    BaseStateType(baseStatTitle: "Meeting totale", baseStatNumber: "13", baseStatGraphImage: "assets/images/assets/contact.png"),
                  ]),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GeneralCardStat(title: "Il tuo Zwap score", stat: "800", cardType: GeneralStatType.TagStat),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GeneralCardStat(title: "Il tuo Zwap score", stat: "14 meetings", cardType: GeneralStatType.TagText),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GeneralCardStat(title: "Il tuo Zwap score", stat: "14 meetings", cardType: GeneralStatType.TagText),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: BaseText(
                      texts: ["475 contatti"],
                      baseTextsType: [BaseTextType.subTitle],
                      textsColor: [DesignColors.greyPrimary],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Filters(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



}