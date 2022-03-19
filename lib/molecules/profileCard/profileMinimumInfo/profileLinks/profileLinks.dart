/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING DESIGN SYSTEM KIT COMPONENTS
import 'package:zwap_design_system/objects/objects.dart';

import 'package:zwap_design_system/molecules/moleculesText/smallTitle/zwapSmallTitle.dart';
import 'package:zwap_design_system/molecules/responsiveElements/profileSocialLink.dart';


/// The profile links section inside the profile card
class ProfileLinks extends StatelessWidget {

  /// The list of socials for this profile
  final List<SocialLink>? socials;

  ProfileLinks({
    Key? key,
    this.socials,
  }) : super(key: key);

  /// It gets the statuses row inside the profile card
  Widget _getProfileLinksRow() {
    Widget socials = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: ResponsiveRow<List<Widget>>(
            customInternalPadding: EdgeInsets.only(right: 10, bottom: 10),
            children: List<Widget>.generate(this.socials!.length, ((index) => ProfileSocialLink(socialLink: this.socials![index]))),
          ),
        )
      ],
    );
    return this.socials != null && this.socials!.length > 0
        ? LayoutBuilder(builder: (item, constraints) {
            return socials;
          })
        : Container();
  }

  Widget buildBody(BuildContext context) {
    Widget titleSection = this.socials == null || this.socials!.length == 0
        ? Padding(padding: EdgeInsets.symmetric(vertical: 4), child: ZwapSmallTitle(title: Utils.translatedText("profile_links_title")))
        : Container();
    Widget linksContainer = this._getProfileLinksRow();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleSection,
        this.socials != null && this.socials!.length > 0 ? linksContainer : Container()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return this.buildBody(context);
  }
}
