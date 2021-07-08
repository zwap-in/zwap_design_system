/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

import 'components/components.dart';


/// The state of the network card with the changeNotifier class
class NetworkCardState extends ChangeNotifier{

  /// Elements inside this network card
  final List<TupleType<DateTime, User>> elements;

  /// The pageNumber to fetch more data
  final int pageNumber;

  /// Callback function to fetch more data
  final Function(int pageNumber) fetchMoreData;

  NetworkCardState({
    required this.elements,
    required this.pageNumber,
    required this.fetchMoreData
  });

}


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


  @override
  Widget build(BuildContext context) {
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
                    child: GeneralCardStat(title: Utils.translatedText("zwapPoints"),
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
                  Consumer<NetworkCardState>(
                      builder: (builder, provider, child){
                        return InfiniteScroll<TupleType<DateTime, User>>(
                            elements: provider.elements,
                            pageNumber: provider.pageNumber + 1,
                            fetchMoreData: (int pageNumber) => provider.fetchMoreData(pageNumber),
                            dynamicWidget: (TupleType<DateTime, User> element) => NetworkItemCard(
                              userData: element.b,
                              lastMeeting: element.a,
                            )
                        );
                      }
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