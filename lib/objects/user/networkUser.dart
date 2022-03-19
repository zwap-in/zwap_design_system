/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/objects/userObjects/userObjects.dart';

import 'publicUser.dart';

/// Data model about the public profile user data
class NetworkUser extends PublicUser{

  final String email;

  NetworkUser({
    required this.email,
    required int pk,
    required String name,
    required String surname,
    required String username,
    required String bio,
    required String? avatarImage,
    required CityData? location,
    required RoleData? roleData,
    required CompanyData? companyData,
    required List<Opportunity>? opportunities,
    required List<StatusModel>? statuses,
    required List<SocialLink>? socials,
    required String? topOfMind,
    required List<Membership>? spaces,
    required PublicUser? invitedBy,
    required List<LanguageData>? languages,
    required bool isTopUser,
    required int totalMeetings,
    required bool isPremium,
  }) : super(
      pk: pk,
      name: name,
      surname: surname,
      username: username,
      bio: bio,
      avatarImage: avatarImage,
      location: location,
      role: roleData,
      company: companyData,
      opportunities: opportunities,
      statuses: statuses,
      socials: socials,
      topOfMind: topOfMind,
      spaces: spaces,
      isTopUser: isTopUser,
      totalMeetings: totalMeetings,
      invitedBy: invitedBy,
      languages: languages,
    isPremium: isPremium
  );

  factory NetworkUser.fromJson(Map<String, dynamic> json){
    return NetworkUser(
      email: json['email'],
        pk: json['pk'],
        name: json['name'],
        surname: json['surname'],
        username: json['username'],
        isTopUser: json['is_top_user'],
        isPremium: json['is_premium'],
        totalMeetings: json['total_meetings'],
        bio: json['bio'],
        avatarImage: json['avatar_image'] ?? "",
        location: json.containsKey("location") ? CityData.fromJson(json) : null,
        roleData: json.containsKey("role") ? RoleData.fromJson(json) : null,
        companyData: json.containsKey("company") ? CompanyData.fromJson(json) : null,
        opportunities: json.containsKey("opportunities") ? List<Opportunity>.generate(json['opportunities'].length, (index) => Opportunity.fromJson(json['opportunities'][index])) : null,
        socials: json.containsKey("socials") ? List<SocialLink>.generate(json['socials'].length, (index) => SocialLink.fromJson(json['socials'][index])) : null,
        statuses: json.containsKey("statuses") ? List<StatusModel>.generate(json['statuses'].length, (index) => StatusModel.fromJson(json['statuses'][index])) : null,
        topOfMind: json['top_of_mind'],
        spaces: json.containsKey("spaces") ? List<Membership>.generate(json['spaces'].length, (index) => Membership.fromJson(json['spaces'][index])) : null,
        invitedBy: PublicUser.fromJson(json),
        languages: json.containsKey("languages") ? List<LanguageData>.generate(json['languages'].length, (index) => LanguageData.fromJson(json['languages'][index])) : null
    );
  }
}