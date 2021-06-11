/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';

import 'package:flutter_responsive_layouts/flutter_responsive_layouts.dart';

/// standard class to check which device dimensions is it
class Dimensions{

  /// Check if the current device is a very small device
  bool isSmallDevice(BuildContext? context, int? maxWidth){
    return GenericSmall(context, null, maxWidth).isPortraitLandscape();
  }

  /// Check if the current device is a standard mobile device
  bool isStandardMobile(BuildContext? context, int? maxWidth){
    return GenericPhone(context, null, maxWidth).isPortraitLandscape();
  }

  /// Check if the current device is a tablet device
  bool isTablet(BuildContext? context, int? maxWidth){
    return GenericTablet(context, null, maxWidth).isPortraitLandscape();
  }

  /// Check if the current device is a medium device
  bool isMedium(BuildContext? context, int? maxWidth){
    return GenericMedium(context, null, maxWidth).isPortraitLandscape();
  }

  /// Check if the current device is a desktop
  bool isDesktop(BuildContext? context, int? maxWidth){
    return GenericDesktop(context, null, maxWidth).isPortraitLandscape();
  }

}