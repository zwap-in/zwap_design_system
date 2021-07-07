import 'package:flutter/cupertino.dart';

import 'package:zwap_design_system/zwap_design_system.dart';

import 'titleItem/titleItem.dart';

class NetworkItemCard extends StatelessWidget{

  final User userData;

  final DateTime lastMeeting;

  NetworkItemCard({Key? key,
    required this.userData,
    required this.lastMeeting
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      bottomDividerColor: DesignColors.greyPrimary,
      title: TitleItem(
          firstName: this.userData.firstName,
          lastName: this.userData.lastName,
          role: this.userData.customData['role'] ?? "",
          company: this.userData.customData['company'] ?? "",
          bioProfile: this.userData.profileBio,
          starsReview: this.userData.customData["starsReview"] ?? "-1",
          lastMeeting: this.lastMeeting
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: BaseText(
            texts: ["${Utils.translatedText("infoAbout")} ${this.userData.firstName}"],
            baseTextsType: [BaseTextType.title],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: BaseInput(
            placeholderText: "${Utils.translatedText("writePrivateNote")} ${this.userData.firstName}",
            changeValue: (dynamic value) => {},
            inputType: InputType.inputArea,
            validateValue: (dynamic value) => true,
            maxLines: 3,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: IconText(
                    iconImage: "assets/images/assets/linkedin.png",
                    text: BaseText(
                      texts: ["Linkedin"],
                      baseTextsType: [BaseTextType.normal],
                    ),
                  ),
                ),
                flex: 0,
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: IconText(
                    iconImage: "assets/images/assets/gmail.png",
                    text: BaseText(
                      texts: ["Email thread"],
                      baseTextsType: [BaseTextType.normal],
                    ),
                  ),
                ),
                flex: 0,
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: IconText(
                    iconImage: "assets/images/assets/contact.png",
                    text: BaseText(
                      texts: ["${this.userData.customData["commonPeople"] ?? "0"} ${Utils.translatedText("alreadyCommonPeople")}"],
                      baseTextsType: [BaseTextType.normal],
                    ),
                  ),
                ),
                flex: 0,
              ),
            ],
          ),
        )
      ],

    );
  }


}