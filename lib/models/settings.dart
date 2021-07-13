/// The settings type in base of the dynamic data
enum SettingsType{
  SettingsInputText,
  SettingsInputNumber,
  SettingsInputPassword,
  SettingsSocial,
  SettingsSwitch,
  SettingsDropDown,
}

/// The settings element to display dynamically
class SettingElement{

  /// The settings title
  final String settingsTitle;

  /// The settings subtitle
  final String? settingsSubTitle;

  /// The settings subTitle
  final SettingsType settingsType;

  /// The settings title value to save the data
  final String settingsTitleValue;

  /// The optionally settings options
  final List<String>? settingsOptions;

  /// The custom regex to validate this settings
  final String? regexValidate;

  SettingElement({
    required this.settingsTitle,
    this.settingsSubTitle,
    required this.settingsType,
    required this.settingsTitleValue,
    required this.regexValidate,
    this.settingsOptions
  }){
    if(this.settingsType == SettingsType.SettingsDropDown){
      assert(this.settingsOptions != null && this.settingsOptions!.length != 0, "Setting options must be not null or it must has the length not equal to 0 if settingsType is a dropdown");
    }
    else{
      assert(this.settingsOptions == null || this.settingsOptions!.length == 0, "Setting options must be null or it must has the length equal to 0 if settingsType is not a dropdown");
    }
    if(this.settingsType == SettingsType.SettingsInputText || this.settingsType == SettingsType.SettingsInputNumber || this.settingsType == SettingsType.SettingsInputPassword){
      assert(this.regexValidate != null, "regex validate must be not null on settings type equal to some input");
    }
    else{
      assert(this.regexValidate == null, "regex validate must be null on settings type not equal to some input");
    }
  }

  factory SettingElement.fromJson(Map<String, dynamic> json) {
    return SettingElement(
      settingsSubTitle: json['settings_subtitle'],
      settingsType: json['settings_type'],
      settingsTitle: json['settings_title'],
      regexValidate: json['regex_validate'],
      settingsTitleValue: json['settings_title_value'],
      settingsOptions: json.containsKey("settings_options") ? json['settings_options'] : null
    );
  }

  /// Convert a list of json in a list of SettingsElement
  static List<SettingElement> parseSettings(List<Map<String, dynamic>> jsonBody){
    List<SettingElement> settings = [];
    jsonBody.forEach((element) {
      settings.add(SettingElement.fromJson(element));
    });
    return settings;
  }
}