/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/objects/objects.dart';

class PublicUser{

  /// Primary key about the user data
  final int pk;

  /// The name for this user data
  String name;

  /// The surname for this user data
  String surname;

  /// The username for this user data
  final String username;

  /// Optionally bio value for this user data
  String? bio;

  /// It gets the avatar pic path
  String? avatarImage;

  /// Optionally location value for this user data
  CityData? location;

  /// Optionally role value for this user data
  RoleData? role;

  /// Optionally company value for this user data
  CompanyData? company;

  /// Optionally opportunities value for this user data
  List<Opportunity>? opportunities;

  /// Optionally statuses value for this user data
  List<StatusModel>? statuses;

  /// Optionally socials value for this user data
  List<SocialLink>? socials;

  /// Optionally top of mind text value for this user data
  String? topOfMind;

  /// Optionally list of spaces for this user data
  final List<Membership>? spaces;

  /// Optionally user who invited this user data
  final PublicUser? invitedBy;

  /// Optionally list of languages for this user data
  List<LanguageData>? languages;

  /// Optionally bool flag to check if this user data is verified or not
  final bool isTopUser;

  /// The number of total meetings
  final int totalMeetings;

  final bool isPremium;

  PublicUser({
    required this.pk,
    required this.name,
    required this.surname,
    required this.username,
    required this.isTopUser,
    required this.totalMeetings,
    required this.isPremium,
    this.bio,
    this.avatarImage,
    this.location,
    this.role,
    this.company,
    this.opportunities,
    this.statuses,
    this.socials,
    this.topOfMind,
    this.spaces,
    this.invitedBy,
    this.languages,
  });

  String get getBio => this.bio != null ? this.bio! : "";

  List<SocialLink> get getSocialLink => this.socials != null ? this.socials! : List<SocialLink>.empty();

  List<StatusModel> get getStatuses => this.statuses != null ? this.statuses! : List<StatusModel>.empty();

  List<Opportunity> get getOpportunities => this.opportunities != null ? this.opportunities! : List<Opportunity>.empty();

  String get getTopOfMind => this.topOfMind != null ? this.topOfMind! : "";

  List<Membership> get getSpaces => this.spaces != null ? this.spaces! : List<Membership>.empty();

  List<LanguageData> get getLanguages => this.languages != null ? this.languages! : List<LanguageData>.empty();

  String get getLocationInfo => "";

  String get getRoleCompanyInfo => "";

  String get getAvatarPic => this.avatarImage ?? "";

  bool get hasMinimumInfo => this.getStatuses.length >= 3 && this.bio != null && this.avatarImage != null && this.getOpportunities.length >= 1;

  factory PublicUser.fromJson(Map<String, dynamic> json){
    return PublicUser(
      pk: json['pk'],
      name: json['name'],
      surname: json['surname'],
      username: json['username'],
      isTopUser: json['is_top_user'],
      isPremium: json['is_premium'],
      totalMeetings: json['total_meetings'],
      bio: json['bio'],
      avatarImage: json['avatar_image'] ?? "",
        location: json.containsKey("location") && json['location'] != null ? CityData.fromJson(json['location']) : null,
        role: json.containsKey("role") && json['role'] != null ? RoleData.fromJson(json['role']) : null,
        company: json.containsKey("company") && json['company'] != null ? CompanyData.fromJson(json['company']) : null,
        opportunities: json.containsKey("opportunities") && json['opportunities'] != null ? List<Opportunity>.generate(json['opportunities'].length, (index) => Opportunity.fromJson(json['opportunities'][index])) : null,
        socials: json.containsKey("socials") && json['socials'] != null ? List<SocialLink>.generate(json['socials'].length, (index) => SocialLink.fromJson(json['socials'][index])) : null,
        statuses: json.containsKey("statuses") && json['statuses'] != null ? List<StatusModel>.generate(json['statuses'].length, (index) => StatusModel.fromJson(json['statuses'][index])) : null,
        topOfMind: json['top_of_mind'],
        spaces: json.containsKey("spaces") && json['spaces'] != null ? List<Membership>.generate(json['spaces'].length, (index) => Membership.fromJson(json['spaces'][index])) : null,
        invitedBy: null,
        languages: json.containsKey("languages") && json['languages'] != null ? List<LanguageData>.generate(json['languages'].length, (index) => LanguageData.fromJson(json['languages'][index])) : null
    );
  }


}