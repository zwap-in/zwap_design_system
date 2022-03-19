/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:zwap_design_system/objects/objects.dart';

/// IMPORTING LOCAL COMPONENTS
import 'profileBio/profileBio.dart';
import 'profileLinks/profileLinks.dart';
import 'profileOpportunities/profileOpportunities.dart';
import 'profileTopOfMind/profileTopOfMind.dart';
import 'profileMembership/profileMembership.dart';
import 'profileStatuses/profileStatuses.dart';

/// The minimum info component inside the profile card
class ProfileMinimumInfo extends StatelessWidget {

  final PublicUser publicUser;

  ProfileMinimumInfo({Key? key,
    required this.publicUser
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: ProfileBio(
            userBio: this.publicUser.getBio,
          ),
        ),
        this.publicUser.getSocialLink.length > 0
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: ProfileLinks(
                  socials: this.publicUser.getSocialLink,
                ),
              )
            : Container(),
        this.publicUser.getStatuses.length > 0
            ? Padding(
                padding: EdgeInsets.only(top: 20, bottom: 5),
                child: ProfileStatuses(
                  statuses: this.publicUser.getStatuses,
                ),
              )
            : Container(),
        this.publicUser.getOpportunities.length > 0
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ProfileOpportunities(
                  opportunities: Map<Opportunity, bool>.fromIterable(
                      this.publicUser.getOpportunities, key: (item) => item, value: (item) => false
                  ),
                ),
              )
            : Container(),
        this.publicUser.getTopOfMind != ""
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ProfileTopOfMind(
                  topOfMind: this.publicUser.getTopOfMind,
                ),
              )
            : Container(),
        this.publicUser.getSpaces.length > 0
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ProfileMembership(
                  spaces: this.publicUser.getSpaces,
                ),
              )
            : Container(),
      ],
    );
  }
}
