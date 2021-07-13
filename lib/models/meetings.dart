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

}

/// The network data class model
class NetworkData{

  /// Mapping each meeting details with any user
  final Map<User, MeetingDetails> networkUser;

  /// The stats behind your network
  final NetworkStats stats;

  NetworkData({required this.networkUser, required this.stats});

}

enum FilterType{
  inputText,
  inputDropDown,
  buttonSide
}

class NetworkFilterElement{

  final String networkTitle;

  final String networkSubTitle;

  final FilterType filterType;

  final String placeholder;

  final List<String> filtersOptions;

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
      filterKeyName: json['filterKeyName'],
      placeholder: json['placeholder']
    );
  }

}

class ScheduleDataMeetings{

  final List<int> daysRange;

  final Map<int, TimeOfDay> slotsMapping;

  final Map<String, NetworkFilterElement> filters;

  ScheduleDataMeetings({
    required this.daysRange,
    required this.slotsMapping,
    required this.filters,
  });

  factory ScheduleDataMeetings.fromJson(Map<String, dynamic> json){
    Map<String, NetworkFilterElement> filters = {};
    json['filters'].forEach((value) {
      NetworkFilterElement currentFilter = NetworkFilterElement.fromJson(value);
      filters[currentFilter.filterKeyName] = currentFilter;
    }
    );
    return ScheduleDataMeetings(
        daysRange: json['days_range'],
        slotsMapping: json['slots_mapping'],
        filters: filters
    );
  }


}