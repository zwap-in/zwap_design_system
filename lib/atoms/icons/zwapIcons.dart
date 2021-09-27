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
    "microsoft": IconData(
        0xe800,
        fontFamily: ZwapIcons.iconFamily,
        fontPackage: ZwapIcons.fontPackage

    ),
    "google": IconData(
        0xe801,
        fontFamily: ZwapIcons.iconFamily,
        fontPackage: ZwapIcons.fontPackage
    ),
    "twitter": IconData(
        0xe802,
        fontFamily: ZwapIcons.iconFamily,
        fontPackage: ZwapIcons.fontPackage
    ),
  };
}
