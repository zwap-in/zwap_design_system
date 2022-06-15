import 'package:freezed_annotation/freezed_annotation.dart';

part 'tmp.freezed.dart';
part 'tmp.g.dart';

@freezed
class UpdateNotificationSettingsArgs with _$UpdateNotificationSettingsArgs {
  factory UpdateNotificationSettingsArgs.disableAll({
    @JsonKey(name: 'weekly_signup') @Default(false) bool weeklySignup,
    @JsonKey(name: 'new_features') @Default(false) bool newFeatures,
    @JsonKey(name: 'community') @Default(false) bool community,
    @JsonKey(name: 'match_proposal') @Default(false) bool matchProposal,
  }) = _DisableAllNotificationSettingsArgs;

  factory UpdateNotificationSettingsArgs({
    @JsonKey(name: 'weekly_signup') required bool weeklySignup,
    @JsonKey(name: 'new_features') required bool newFeatures,
    @JsonKey(name: 'community') required bool community,
    @JsonKey(name: 'match_proposal') required bool matchProposal,
  }) = _UpdateNotificationSettingsArgs;

  factory UpdateNotificationSettingsArgs.fromJson(Map<String, dynamic> json) => _$UpdateNotificationSettingsArgsFromJson(json);
}
