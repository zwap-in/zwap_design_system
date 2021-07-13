import 'interests.dart';
import 'targets.dart';

/// The profile data
class User{

  /// The pk number
  final int pk;

  /// The first name
  final String firstName;

  /// The last name
  final String lastName;

  /// The profile bio
  final String profileBio;

  /// The custom data
  final Map<String, dynamic> customData;

  /// The list of the interests
  final List<InterestData> interests;

  /// The list of the targets
  final List<TargetData> targetsData;

  User({
    required this.pk,
    required this.firstName,
    required this.lastName,
    required this.profileBio,
    required this.customData,
    required this.interests,
    required this.targetsData,
  });

  /// Convert the profile data from any json call to a struct data
  factory User.fromJson(Map<String, dynamic> json){

    List<InterestData> interests = [];
    json['interests'].toList().asMap().forEach((key, dynamic value) {
      interests.add(InterestData.fromJson(value));
    });

    List<TargetData> targets = [];
    json['targets'].toList().asMap().forEach((key, dynamic value) {
      targets.add(TargetData.fromJson(value));
    });

    return User(
      pk: json['pk'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profileBio: json['profile_bio'],
      customData: json['custom_data'],
      interests: interests,
      targetsData: targets,
    );
  }

  /// Parsing list of json inside list of users
  static List<User> parseUsers(List<Map<String, dynamic>> jsonBody){
    List<User> users = [];
    jsonBody.forEach((element) {
      users.add(User.fromJson(element));
    });
    return users;
  }

}
