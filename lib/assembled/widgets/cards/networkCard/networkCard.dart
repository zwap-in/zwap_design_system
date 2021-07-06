/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

import 'components/components.dart';


/// Custom widget to display the network card
class NetworkCard extends StatelessWidget{

  /// The network stats to show inside this
  final NetworkData networkStats;

  /// The current logged user
  final User currentUser;

  NetworkCard({Key? key,
    required this.networkStats,
    required this.currentUser
  }): super(key: key);


  /// The list of the users to show inside the network screen
  List<Widget> finals(){
    List<Widget> finals = [];
    this.networkStats.networkUser.forEach((key, value) {
      finals.add(
        NetworkItemCard(userData: key, lastMeeting: value.dateTimeStart,)
      );
    });
    return finals;
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> finals = this.finals();
    return CustomCard(
      childComponent: VerticalScroll(
        childComponent: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  HeaderNetwork(firstName: this.currentUser.firstName, lastName: this.currentUser.lastName, baseStateType: [
                    BaseStateType(baseStatTitle: Utils.translatedText("totalMeeting"),
                        baseStatNumber: this.networkStats.stats.meetings.toString(),
                        iconData: IconData(Utils.iconData("cameraIcon"), fontFamily: "zwapIcon")),
                    BaseStateType(baseStatTitle: Utils.translatedText("totalStreak"),
                        baseStatNumber: this.networkStats.stats.streak.toString(),
                        iconData: IconData(Utils.iconData("cameraIcon"), fontFamily: "zwapIcon")),
                    BaseStateType(baseStatTitle: Utils.translatedText("invitedFriends"),
                        baseStatNumber: this.networkStats.stats.invitedFriends.toString(),
                        iconData: IconData(Utils.iconData("cameraIcon"), fontFamily: "zwapIcon")),
                  ]),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GeneralCardStat(title: Utils.translatedText("zwapScoreTitle"),
                        stat: this.networkStats.stats.zwapScore.toString(),
                        cardType: GeneralStatType.TagStat),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GeneralCardStat(title: Utils.translatedText("generatedMeetingsTitle"),
                        stat: "${this.networkStats.stats.generatedMeetings.toString()} ${Utils.translatedText("meetings")}",
                        cardType: GeneralStatType.TagText),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GeneralCardStat(title: Utils.translatedText("zwapPointsTitle"),
                        stat: "${this.networkStats.stats.zwapPoints.toString()} ${Utils.translatedText("zwapPoints")}",
                        cardType: GeneralStatType.TagText),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: BaseText(
                      texts: ["${this.networkStats.stats.totalContacts} ${Utils.translatedText("contactsTitle")}"],
                      baseTextsType: [BaseTextType.subTitle],
                      textsColor: [DesignColors.greyPrimary],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Filters(
                      showFiltersCallBack: () => {},
                      exportContactsCallBack: () => {},
                      importContactsCallBack: () => {},
                      searchCallBack: (String searchKey) => {},
                    ),
                  ),
                  for(int i = 0; i < finals.length; i++) finals[i]
                ],

              ),
            ),
          ],
        ),
      ),
    );
  }



}