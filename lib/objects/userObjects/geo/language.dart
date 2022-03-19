/// The data model about any language data
class LanguageData{

  /// The language name for this language data model
  final String languageName;

  /// The flag code this language data model
  final String flagCode;

  /// The language code for this language
  final String languageCode;

  LanguageData({
    required this.languageName,
    required this.flagCode,
    required this.languageCode
  });

  factory LanguageData.fromJson(Map<String, dynamic> json){
    return LanguageData(
        languageName: json['language_name'],
        flagCode: json['flag_code'],
        languageCode: json['language_code']
    );
  }

}
