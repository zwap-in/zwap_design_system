import 'package:flutter/material.dart';

import 'user.dart';

/// The class to handle the details about any meeting
class MeetingDetails{

  /// the pk of the meeting
  final int pk;

  /// The datetime start
  final DateTime dateTimeStart;

  /// The datetime end
  final DateTime dateTimeEnd;

  /// The meeting title
  final String title;

  MeetingDetails({
    required this.pk,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.title});

  factory MeetingDetails.fromJson(Map<String, dynamic> json){
    return MeetingDetails(
        pk: json['pk'],
        dateTimeStart: json['dateTimeStart'],
        dateTimeEnd: json['dateTimeEnd'],
        title: json['title']
    );
  }

  /// Parsing list of json inside a map with datetime as key and a list of MeetingDetails as value
  static Map<DateTime, List<MeetingDetails>> mapParsing(List<Map<String, dynamic>> jsonBody) {
    Map<DateTime, List<MeetingDetails>> mapping = {};
    jsonBody.forEach((element){
      MeetingDetails meetingElement = MeetingDetails.fromJson(element);
      if(!mapping.containsKey(meetingElement.dateTimeStart)){
        mapping[meetingElement.dateTimeStart] = [];
      }
      mapping[meetingElement.dateTimeStart]!.add(meetingElement);
    });
    return mapping;
  }

  /// Parsing a list of json to a list of meeting details
  static List<MeetingDetails> parseMeetings(List<Map<String, dynamic>> jsonBody){
    List<MeetingDetails> meetings = [];
    jsonBody.forEach((element) {
      meetings.add(MeetingDetails.fromJson(element));
    });
    return meetings;
  }
}

/// The network stats class model
class NetworkStats{

  /// Meetings number
  final int meetings;

  /// Streak number
  final int streak;

  /// Invited friends number
  final int invitedFriends;

  /// Zwap score
  final int zwapScore;

  /// Generated meetings number
  final int generatedMeetings;

  /// Zwap points
  final int zwapPoints;

  /// Total contacts
  final int totalContacts;

  NetworkStats({
    required this.meetings, required this.streak,
    required this.invitedFriends, required this.zwapScore,
    required this.generatedMeetings, required this.zwapPoints,
    required this.totalContacts
  });
  
  factory NetworkStats.fromJson(Map<String, dynamic> json){
    return NetworkStats(
        meetings: json['meetings'], 
        streak: json['streak'], 
        invitedFriends: json['invited_friends'],
        zwapScore: json['zwap_score'],
        generatedMeetings: json['generated_meetings'], 
        zwapPoints: json['zwap_points'], 
        totalContacts: json['total_contacts']
    );
  }

}

enum FilterType{
  inputText,
  inputDropDown,
  buttonSide
}

class NetworkFilterElement{

  /// The network filter's title
  final String networkTitle;

  /// The network filter's subtitle
  final String networkSubTitle;

  /// The network filter's type
  final FilterType filterType;

  /// The network filter's placeholder
  final String placeholder;

  /// The network filter's options
  final List<String> filtersOptions;

  /// The network filter's key name
  final String filterKeyName;

  NetworkFilterElement({
    required this.networkTitle,
    required this.networkSubTitle,
    required this.filtersOptions,
    required this.filterType,
    required this.filterKeyName,
    required this.placeholder
  });

  factory NetworkFilterElement.fromJson(Map<String, dynamic> json){
    return NetworkFilterElement(
      networkTitle: json['network_title'],
      networkSubTitle: json['network_subtitle'],
      filtersOptions: json['filter_options'],
      filterType: json['filter_type'],
      filterKeyName: json['filter_key_name'],
      placeholder: json['placeholder']
    );
  }

  /// Parsing a list of json into list of networkFilters
  static List<NetworkFilterElement> parseNetworkFilters(List<Map<String, dynamic>> jsonBody){
    List<NetworkFilterElement> networkFilters = [];
    jsonBody.forEach((element) {
      networkFilters.add(NetworkFilterElement.fromJson(element));
    });
    return networkFilters;
  }


}

/// The data to setup the schedule layout
class ScheduleDataMeetings{

  /// The slots per day mapping
  final Map<int, List<TimeOfDay>> slotsMapping;

  /// Mapping each filter with its key
  final Map<String, NetworkFilterElement> filters;

  ScheduleDataMeetings({
    required this.slotsMapping,
    required this.filters,
  });

  factory ScheduleDataMeetings.fromJson(Map<String, dynamic> json){
    List<NetworkFilterElement> networkFilters = NetworkFilterElement.parseNetworkFilters(json['filters']);
    Map<String, NetworkFilterElement> filters = {};
    networkFilters.forEach((element) {
      filters[element.filterKeyName] = element;
    });
    Map<int, List<TimeOfDay>> finalSlotsMapping = {};
    Map<int, List<Map<String, int>>> slotsMapping = json['slots_mapping'];
    slotsMapping.forEach((int weekDay, List<Map<String, int>> days) {
      List<TimeOfDay> slots = [];
      days.forEach((element) {
        slots.add(TimeOfDay(hour: element['hour']!, minute: element['minutes']!));
      });
      finalSlotsMapping[weekDay] = slots;
    });
    return ScheduleDataMeetings(
        slotsMapping: finalSlotsMapping,
        filters: filters
    );
  }


}