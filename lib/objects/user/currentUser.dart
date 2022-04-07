/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/objects/userObjects/userObjects.dart';

import 'networkUser.dart';

class CurrentUser extends NetworkUser {
  CurrentUser({
    required String email,
    required int pk,
    required String name,
    required String surname,
    required String username,
    required String bio,
    required bool isTopUser,
    required int totalMeetings,
    required bool isPremium,
    String? avatarImage,
    CityData? location,
    RoleData? roleData,
    CompanyData? companyData,
    List<Opportunity>? opportunities,
    List<StatusModel>? statuses,
    List<SocialLink>? socials,
    String? topOfMind,
    List<Membership>? spaces,
    InvitedByUser? invitedBy,
    List<LanguageData>? languages,
  }) : super(
            email: email,
            pk: pk,
            name: name,
            surname: surname,
            username: username,
            bio: bio,
            avatarImage: avatarImage,
            location: location,
            roleData: roleData,
            companyData: companyData,
            opportunities: opportunities,
            statuses: statuses,
            socials: socials,
            topOfMind: topOfMind,
            spaces: spaces,
            isTopUser: isTopUser,
            totalMeetings: totalMeetings,
            invitedBy: invitedBy,
            languages: languages,
            isPremium: isPremium);

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
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
        location: json.containsKey("location") && json['location'] != null ? CityData.fromJson(json['location']) : null,
        roleData: json.containsKey("role") && json['role'] != null ? RoleData.fromJson(json['role']) : null,
        companyData: json.containsKey("company") && json['company'] != null ? CompanyData.fromJson(json['company']) : null,
        opportunities: json.containsKey("opportunities") && json['opportunities'] != null
            ? List<Opportunity>.generate(json['opportunities'].length, (index) => Opportunity.fromJson(json['opportunities'][index]))
            : null,
        socials: json.containsKey("socials") && json['socials'] != null
            ? List<SocialLink>.generate(json['socials'].length, (index) => SocialLink.fromJson(json['socials'][index]))
            : null,
        statuses: json.containsKey("statuses") && json['statuses'] != null
            ? List<StatusModel>.generate(json['statuses'].length, (index) => StatusModel.fromJson(json['statuses'][index]))
            : null,
        topOfMind: json['top_of_mind'],
        spaces: json.containsKey("spaces") && json['spaces'] != null
            ? List<Membership>.generate(json['spaces'].length, (index) => Membership.fromJson(json['spaces'][index]))
            : null,
        invitedBy: null,
        languages: json.containsKey("languages") && json['languages'] != null
            ? List<LanguageData>.generate(json['languages'].length, (index) => LanguageData.fromJson(json['languages'][index]))
            : null);
  }
}
