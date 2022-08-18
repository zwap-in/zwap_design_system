/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';
import 'package:taastrap/taastrap.dart';

import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/objects/objects.dart';

/// Custom component to render the social link icon in responsive way
class ProfileSocialLink extends StatelessWidget implements ResponsiveWidget {
  final SocialLink socialLink;

  ProfileSocialLink({Key? key, required this.socialLink}) : super(key: key);

  String get _url {
    if (socialLink.socialUrl.startsWith('https://') || socialLink.socialUrl.startsWith('http://')) return socialLink.socialUrl;
    return 'http://${socialLink.socialUrl}';
  }

  Widget build(BuildContext context) {
    return Tooltip(
      message: socialLink.socialDescription,
      child: InkWell(
        onTap: () => Utils.currentState.openExternalUrl(_url),
        child: Icon(
          parseSocialType(socialLink.socialUrl).icon.icon,
          color: ZwapColors.neutral700,
          size: this.getSize(),
        ),
      ),
    );
  }

  double getSize() {
    return 20;
  }
}
