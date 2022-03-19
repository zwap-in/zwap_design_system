/// IMPORTING THIRD PARTY PACKAGES
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:zwap_design_system/enums/enums.dart';

/// It retrieves the social type in base of the current host domain
SocialType getSocialType(String socialTitle) {
  if (socialTitle.contains("twitter")) {
    return SocialType.twitter;
  } else if (socialTitle.contains("linkedin")) {
    return SocialType.linkedin;
  } else if (socialTitle.contains("instagram")) {
    return SocialType.instagram;
  } else if (socialTitle.contains("facebook")) {
    return SocialType.facebook;
  } else if (socialTitle.contains("github")) {
    return SocialType.github;
  } else if (socialTitle.contains("pinterest")) {
    return SocialType.pinterest;
  } else if (socialTitle.contains("reddit")) {
    return SocialType.reddit;
  } else if (socialTitle.contains("google")) {
    return SocialType.google;
  } else if (socialTitle.contains("microsoft")) {
    return SocialType.microsoft;
  } else {
    return SocialType.other;
  }
}

/// It retrieves the iconData in base of the socialType
FaIcon socialIcon(SocialType socialType) {
  FaIcon socialIcon;
  switch (socialType) {
    case SocialType.twitter:
      socialIcon = FaIcon(FontAwesomeIcons.twitter);
      break;
    case SocialType.linkedin:
      socialIcon = FaIcon(FontAwesomeIcons.linkedin);
      break;
    case SocialType.instagram:
      socialIcon = FaIcon(FontAwesomeIcons.instagram);
      break;
    case SocialType.facebook:
      socialIcon = FaIcon(FontAwesomeIcons.facebook);
      break;
    case SocialType.github:
      socialIcon = FaIcon(FontAwesomeIcons.github);
      break;
    case SocialType.pinterest:
      socialIcon = FaIcon(FontAwesomeIcons.pinterest);
      break;
    case SocialType.reddit:
      socialIcon = FaIcon(FontAwesomeIcons.reddit);
      break;
    case SocialType.other:
      socialIcon = FaIcon(FontAwesomeIcons.externalLinkAlt);
      break;
    case SocialType.google:
      socialIcon = FaIcon(FontAwesomeIcons.google);
      break;
    case SocialType.microsoft:
      socialIcon = FaIcon(FontAwesomeIcons.microsoft);
      break;
    case SocialType.whatsapp:
      socialIcon = FaIcon(FontAwesomeIcons.whatsapp);
      break;
  }
  return socialIcon;
}