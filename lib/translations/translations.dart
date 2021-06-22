import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';


/// Localization class to handle the multi language texts
class LocalizationClass {

  LocalizationClass(this.locale);

  /// The local instance to retrieve the local language
  final Locale locale;

  static LocalizationClass of(BuildContext context) {
    return Localizations.of<LocalizationClass>(context, LocalizationClass)!;
  }

  /// Translation mapping
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'signupTitle': 'ssssss',
      'signupSubtitle': '',
      'signupGoogle': '',
      'useEmail': '',
      'fullName': '',
      'email': '',
      'password': '',
      'acceptTerms': '',
      'signupButton': '',
      'haveAccount': '',
      'loginTitle': '',
      'loginSubtitle': '',
      'loginGoogle': '',
      'loginButton': '',
      'bioStepSignupMenu': '',
      'bioStepSignupTitle': '',
      'bioStepSignupSubtitle': '',
      'bioStepSignupMinChars': '',
      'bioStepSignupExamplesTitle': '',
      'bioStepSignupExampleBio': '',
      'profileStepSignupMenu': '',
      'changePic': 'Change pic',
      'nameInputTitle': '',
      'surnameInputTitle': '',
      'roleInputTitle': '',
      'companyInputTitle': '',
      'sectorInputTitle': '',
      'experienceInputTitle': '',
      'linkedinInputTitle': '',
      'twitterInputTitle': '',
      'areaInputTitle': '',
      'languagesInputTitle': '',
      'zwapDataStepSignupMenu': '',
      'interestedInTitle': 'Interested in',
      'interestedInSubtitle': '',
      'addMoreInterestPlaceholder': '',
      'targetsTitle': 'Targets',
      'targetsSubtitle': '',
      'addMoreInterestsButton': '',
      'details': '',
      'wantTalkAboutTitle': 'I wanna talk about...',
      'wantTalkAboutPlaceholderInput': '',
      'lookingForTitle': '',
      'lookingForPlaceholder': '',
      'cancelButton': 'Cancel',
      'saveButton': 'Save',
      'efficiencyTitle': '',
      'skipButton': '',
      'continueButton': 'Continue',
      'exploreButtonMenu': '',
      'suggestedButtonMenu': '',
      'viewProfileButton': 'View profile',
      'memberOfTitle': 'Member of',
      'cityPlaceholder': "City",
      "rolePlaceholder": "Role",
      "companyPlaceholder": "Company",
      "socialLinkedinPlaceholder": "Linkedin",
      "socialTwitterPlaceholder": "Twitter",
      "invitedByPlaceholder": "Invited by ",
      "askIntro": "Ask an intreo",
      "suggestedUsersTitle": "Suggested users",
      "findPeopleKnows": "Find who knows",
      "commonPeople": "We find common people",
      "profileEfficiency": "Profile efficiency",
      "infoAbout": "Info about ",
      "writePrivateNote": "Write a private note about ",
      "alreadyCommonPeople": "persone in comune",
      "schedule": "Schedule",
      "viewAllMeetings": "View all meetings",
      "nextMeetings": "Next medesesseerewesrserssrdetings",
      "removeButton": "Remove",
      "addButton": "Add",
      "january": "January",
      "february": "February",
      "march": "March",
      "april": "April",
      "may": "May",
      "june": "June",
      "july": "July",
      "august": "August",
      "september": "September",
      "october": "October",
      "november": "November",
      "december": "December",
      "januaryAbbr": "Jan",
      "februaryAbbr": "Feb",
      "marchAbbr": "Mar",
      "aprilAbbr": "Apr",
      "mayAbbr": "May",
      "juneAbbr": "June",
      "julyAbbr": "July",
      "augustAbbr": "Aug",
      "septemberAbbr": "Sept",
      "octoberAbbr": "Oct",
      "novemberAbbr": "Nov",
      "decemberAbbr": "Dec",
      "mondayAbbr": "Mon",
      "tuesdayAbbr": "Tue",
      "wednesdayAbbr": "Wen",
      "thursdayAbbr": "Thu",
      "fridayAbbr": "Fri",
      "saturdayAbbr": "Sat",
      "sundayAbbr": "Sun"
    },
    'it': {
      'signupTitle': '',
      'signupSubtitle': '',
      'signupGoogle': '',
      'useEmail': 'ssssssss',
      'fullName': '',
      'email': '',
      'password': '',
      'acceptTerms': '',
      'signupButton': '',
      'haveAccount': '',
      'loginTitle': '',
      'loginSubtitle': '',
      'loginGoogle': '',
      'loginButton': '',
      'bioStepSignupMenu': '',
      'bioStepSignupTitle': '',
      'bioStepSignupSubtitle': '',
      'bioStepSignupMinChars': '',
      'bioStepSignupExamplesTitle': '',
      'bioStepSignupExampleBio': '',
      'profileStepSignupMenu': '',
      'changePic': 'Cambia foto',
      'nameInputTitle': '',
      'surnameInsputTitle': '',
      'roleInputTitle': '',
      'companyInputTitle': '',
      'sectorInputTitle': '',
      'experienceInputTitle': '',
      'linkedinInputTitle': '',
      'twitterInputTitle': '',
      'areaInputTitle': '',
      'languagesInputTitle': '',
      'zwapDataStepSignupMenu': 's',
      'interestedInTitle': 'Interessato a',
      'interestedInSubtitle': '',
      'addMoreInterestPlaceholder': '',
      'targetsTitle': "Obiettivi",
      'targetsSubtitle': '',
      'addMoreInterestsButton': '',
      'details': '',
      'wantTalkAboutTitle': 'Vorrei parlare di...',
      'wantTalkAboutPlaceholderInput': '',
      'lookingForTitle': '',
      'lookingForPlaceholder': '',
      'cancelButton': 'Annulla',
      'saveButton': 'Salva',
      'efficiencyTitle': '',
      'skipButton': '',
      'continueButton': 'Continue',
      'exploreButtonMenu': '',
      'suggestedButtonMenu': '',
      'viewProfileButton': 'Vedi profilo',
      'memberOfTitle': 'Memdbro di',
      'cityPlaceholder': "Città",
      "rolePlaceholder": "Ruolddo",
      "companyPlaceholder": "Aziesddddnda",
      "socialLinkedinPlaceholder": "Linsddsskedin",
      "socialTwitterPlaceholder": "Twsitter",
      "invitedByPlaceholder": "Idenvsditato da ",
      "askIntro": "Chiedi intro",
      "suggestedUsersTitle": "Utenti suggeriti",
      "findPeopleKnows": "Scopri chi conosce",
      "commonPeople": "Troveremo sperssone in comune",
      "profileEfficiency": "Efficacissa del profilo",
      "infoAbout": "Info su ",
      "writePrivateNote": "Scrivi una nota privata su ",
      "alreadyCommonPeople": "persone in comune",
      "schedule": "Pianifica",
      "viewAllMeetings": "Vedi tutti i meeting",
      "nextMeetings": "Prossimi meeting",
      "removeButton": "Rimuovi",
      "addButton": "Aggiungi",
      "january": "Gennaio",
      "february": "Febbraio",
      "march": "Marzo",
      "april": "Aprile",
      "may": "Maggio",
      "june": "Giugno",
      "july": "Luglio",
      "august": "Agosto",
      "september": "Settembre",
      "october": "Ottobre",
      "november": "Novembre",
      "december": "Dicembre",
      "januaryAbbr": "Gen",
      "februaryAbbr": "Feb",
      "marchAbbr": "Mar",
      "aprilAbbr": "Apr",
      "mayAbbr": "Mag",
      "juneAbbr": "Giu",
      "julyAbbr": "Lug",
      "augustAbbr": "Ago",
      "septemberAbbr": "Sett",
      "octoberAbbr": "Ott",
      "novemberAbbr": "Nov",
      "decemberAbbr": "Dic",
      "mondayAbbr": "Lun",
      "tuesdayAbbr": "Mar",
      "wednesdayAbbr": "Mer",
      "thursdayAbbr": "Gio",
      "fridayAbbr": "Ven",
      "saturdayAbbr": "Sab",
      "sundayAbbr": "Dom"
    },
  };

  /// Retrieve the local text for this key
  String dynamicValue(String key) {
    return _localizedValues[locale.languageCode]![key]!;
  }
}

/// Translation delegation class
class LocalizationClassDelegate extends LocalizationsDelegate<LocalizationClass> {

  const LocalizationClassDelegate();

  /// Check if the current languageCode is supported
  @override
  bool isSupported(Locale locale) => ['en', 'it'].contains(locale.languageCode);

  @override
  Future<LocalizationClass> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<LocalizationClass>(LocalizationClass(locale));
  }

  @override
  bool shouldReload(LocalizationClassDelegate old) => false;
}