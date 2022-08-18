import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum SocialType {
  google,
  microsoft,
  twitter,
  linkedin,
  instagram,
  facebook,
  github,
  pinterest,
  reddit,
  whatsapp,
  other,
}

extension SocialTypeExtension on SocialType {
  FaIcon get icon {
    switch (this) {
      case SocialType.google:
        return FaIcon(FontAwesomeIcons.google);
      case SocialType.microsoft:
        return FaIcon(FontAwesomeIcons.microsoft);
      case SocialType.twitter:
        return FaIcon(FontAwesomeIcons.twitter);
      case SocialType.linkedin:
        return FaIcon(FontAwesomeIcons.linkedin);
      case SocialType.instagram:
        return FaIcon(FontAwesomeIcons.instagram);
      case SocialType.facebook:
        return FaIcon(FontAwesomeIcons.facebook);
      case SocialType.github:
        return FaIcon(FontAwesomeIcons.github);
      case SocialType.pinterest:
        return FaIcon(FontAwesomeIcons.pinterest);
      case SocialType.reddit:
        return FaIcon(FontAwesomeIcons.reddit);
      case SocialType.whatsapp:
        return FaIcon(FontAwesomeIcons.whatsapp);
      case SocialType.other:
        return FaIcon(FontAwesomeIcons.externalLinkAlt);
    }
  }

  String get title {
    switch (this) {
      case SocialType.google:
        return 'Google';
      case SocialType.microsoft:
        return 'Microsoft';
      case SocialType.twitter:
        return 'Twitter';
      case SocialType.linkedin:
        return 'Linkedin';
      case SocialType.instagram:
        return 'Instagram';
      case SocialType.facebook:
        return 'Facebook';
      case SocialType.github:
        return 'Github';
      case SocialType.pinterest:
        return 'Pinterest';
      case SocialType.reddit:
        return 'Reddit';
      case SocialType.whatsapp:
        return 'Whatsapp';
      case SocialType.other:
        return 'Other';
    }
  }
}

/// It retrieves the social type in base of the current host domain
SocialType parseSocialType(String socialTitle) {
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
