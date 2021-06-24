/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The suggested users column card
class SuggestedRow extends StatelessWidget{

  /// The suggested users
  final List<User> users;

  /// custom callBack function to view the profile
  final Function() viewProfile;

  SuggestedRow({Key? key,
    required this.users,
    required this.viewProfile
  });

  /// It retrieves the suggested users elements
  List<Widget> _getChildrenColumn(){
    List<Widget> finals = [];
    this.users.forEach((User element) {
      finals.add(
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: SuggestedCard(profileData: element, viewProfile: (){},),
            ),
            flex: 0,
          )
      );
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: BaseText(
            texts: [LocalizationClass.of(context).dynamicValue("suggestedUsersTitle")],
            baseTextsType: [BaseTextType.title],
          ),
        ),
        HorizontalScroll(
          child: Row(
            children: this._getChildrenColumn(),
          ),
        )
      ],
    );
  }



}