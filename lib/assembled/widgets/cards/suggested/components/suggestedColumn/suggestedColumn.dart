/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:zwap_design_system/base/layouts/verticalScroll/verticalScroll.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The suggested users column card
class SuggestedColumn extends StatelessWidget{

  /// The suggested users
  final List<User> users;

  /// The card width
  final double cardWidth;

  /// custom callBack function to view the profile
  final Function(User profile) viewProfile;

  SuggestedColumn({Key? key,
    required this.cardWidth,
    required this.users,
    required this.viewProfile
  });

  /// It retrieves the suggested users elements
  List<Widget> _getChildrenColumn(){
    List<Widget> finals = [];
    this.users.forEach((User element) {
      finals.add(
          Padding(
            padding: EdgeInsets.all(15),
            child: SuggestedCard(
              profileData: element,
              isCard: false,
              viewProfile: () => this.viewProfile(element),
            ),
          )
      );
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> _children = [
      Padding(
        padding: EdgeInsets.all(20),
        child: BaseText(
          texts: [LocalizationClass.of(context).dynamicValue("suggestedUsersTitle")],
          baseTextsType: [BaseTextType.title],
        ),
      )
    ];

    _children.addAll(this._getChildrenColumn());

    return VerticalScroll(
        childComponent: CustomCard(
            cardWidth: this.cardWidth,
            childComponent: Column(
              children: _children,
            ),
        )
    );
  }



}