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