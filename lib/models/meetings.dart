import 'user.dart';

/// The class to handle the details about any meeting
class MeetingDetails{

  final int pk;

  final DateTime dateTimeStart;

  final DateTime dateTimeEnd;

  final String title;

  MeetingDetails({
    required this.pk,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.title});
}

class NetworkStats{

  final int meetings;

  final int streak;

  final int invitedFriends;

  final int zwapScore;

  final int generatedMeetings;

  final int zwapPoints;

  final int totalContacts;

  NetworkStats({
    required this.meetings, required this.streak,
    required this.invitedFriends, required this.zwapScore,
    required this.generatedMeetings, required this.zwapPoints,
    required this.totalContacts
  });

}

class NetworkData{

  final Map<User, MeetingDetails> networkUser;

  final NetworkStats stats;

  NetworkData({required this.networkUser, required this.stats});


}