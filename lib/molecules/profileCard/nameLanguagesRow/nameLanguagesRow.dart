/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL COMPONENTS
import 'package:zwap_design_system/objects/objects.dart';

import 'subComponents/languageSection.dart';
import 'subComponents/nameSection.dart';

/// The section with name and optionally languages inside the profile card
class NameLanguagesRow extends StatelessWidget {

  /// The user name
  final String name;

  /// The user surname
  final String surname;

  /// Is this user verified or not?
  final bool isTopUser;

  /// The languages mapping info with language name and the language IconData related
  final List<LanguageData> languages;

  final bool isPremium;

  NameLanguagesRow({Key? key,
    required this.name,
    required this.surname,
    required this.isTopUser,
    required this.languages,
    this.isPremium = false
  }) : super(key: key);

  /// It builds the layout for the desktop sizes
  Widget get _desktopLayout {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 30),
            child: NameSection(name: name, surname: surname, isPremium: isPremium, isTopUser: isTopUser,),
          ),
          flex: 0,
          fit: FlexFit.tight,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 5),
            child: LanguageSection(languages: languages,),
          ),
          flex: 0,
          fit: FlexFit.tight,
        ),
      ],
    );
  }

  /// It builds the layout for the mobile sizes
  Widget get _mobileLayout {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 0),
          child:  NameSection(name: name, surname: surname, isPremium: isPremium, isTopUser: isTopUser),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: LanguageSection(languages: languages,),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return getMultipleConditions<Widget>(this._desktopLayout, this._desktopLayout, this._desktopLayout, this._mobileLayout, this._mobileLayout);
  }
}
