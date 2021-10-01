/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// Mapping each icons with each code name and code point
class ZwapIcons {

  /// The default icon family
  static String iconFamily = "ZwapIcons";

  /// The font package name
  static String fontPackage = "zwap_design_system";

  /// The mapping data for each icons
  static Map<String, IconData> icons = {
    "close": IconData(
        0xe800,
        fontFamily: ZwapIcons.iconFamily,
        fontPackage: ZwapIcons.fontPackage
    ),
    "arrow_down": IconData(
        0xe804,
        fontFamily: ZwapIcons.iconFamily,
        fontPackage: ZwapIcons.fontPackage
    ),
    "arrow_up": IconData(
        0xe806,
        fontFamily: ZwapIcons.iconFamily,
        fontPackage: ZwapIcons.fontPackage
    ),
    "meetings_nav": IconData(
        0xe801,
        fontFamily: ZwapIcons.iconFamily,
        fontPackage: ZwapIcons.fontPackage
    ),
    "invite_nav": IconData(
        0xe805,
        fontFamily: ZwapIcons.iconFamily,
        fontPackage: ZwapIcons.fontPackage
    ),
    "network_nav": IconData(
        0xe802,
        fontFamily: ZwapIcons.iconFamily,
        fontPackage: ZwapIcons.fontPackage
    ),
    "explore_nav": IconData(
        0xe803,
        fontFamily: ZwapIcons.iconFamily,
        fontPackage: ZwapIcons.fontPackage
    ),
    "zwap_logo": IconData(
        0xe808,
        fontFamily: ZwapIcons.iconFamily,
        fontPackage: ZwapIcons.fontPackage
    )
  };
}
