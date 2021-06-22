/// The settings type in base of the dynamic data
enum SettingsType{
  SettingsInputText,
  SettingsInputNumber,
  SettingsSocialGoogle,
  SettingsSocialLinkedin,
  SettingsSwitch,
  SettingsDropDown,
}

/// The settings element to display dynamically
class SettingElement{

  /// The settings title
  final String settingsTitle;

  /// The settings subtitle
  final String settingsSubTitle;

  /// The settings subTitle
  final SettingsType settingsType;

  /// The optionally settings options
  final List<String>? settingsOptions;

  SettingElement({
    required this.settingsTitle,
    required this.settingsSubTitle,
    required this.settingsType,
    this.settingsOptions
  }){
    if(this.settingsType == SettingsType.SettingsDropDown){
      assert(this.settingsOptions != null && this.settingsOptions!.length != 0, "Setting options must be not null or it must has the length not equal to 0 if settingsType is a dropdown");
    }
    else{
      assert(this.settingsOptions == null || this.settingsOptions!.length == 0, "Setting options must be null or it must has the length equal to 0 if settingsType is not a dropdown");
    }
  }

  factory SettingElement.fromJson(Map<String, dynamic> json) {
    return SettingElement(
      settingsSubTitle: json['settings_subtitle'],
      settingsType: json['settings_type'],
      settingsTitle: json['settings_title'],
      settingsOptions: json.containsKey("settings_options") ? json['settings_options'] : null
    );
  }
}