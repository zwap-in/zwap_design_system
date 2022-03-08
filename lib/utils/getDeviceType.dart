import 'package:universal_html/html.dart' as html;

enum DeviceType { smartphone, tablet, desktop }
enum DeviceBrand { apple, android, other }

DeviceType getDeviceType() {
  String userAgent = html.window.navigator.userAgent.toString().toLowerCase();
  // smartphone
  if (userAgent.contains("iphone") || userAgent.contains("android")) return DeviceType.smartphone;

  // tablet
  if (userAgent.contains("ipad") ||
      (html.window.navigator.platform?.toLowerCase().contains("macintel") ?? false) && (html.window.navigator.maxTouchPoints ?? 0) > 0)
    return DeviceType.tablet;

  return DeviceType.desktop;
}

/// [Other] doesn't not exclude android or ios
DeviceBrand getDeviceBrand() {
  String userAgent = html.window.navigator.userAgent.toString().toLowerCase();
  // smartphone
  if (userAgent.contains("iphone")) return DeviceBrand.apple;
  if (userAgent.contains("android")) return DeviceBrand.android;

  // tablet
  if (userAgent.contains("ipad")) return DeviceBrand.apple;
  if ((html.window.navigator.platform?.toLowerCase().contains("macintel") ?? false) && (html.window.navigator.maxTouchPoints ?? 0) > 0)
    return DeviceBrand.apple;

  return DeviceBrand.other;
}
