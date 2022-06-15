// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DisableAllNotificationSettingsArgs
    _$$_DisableAllNotificationSettingsArgsFromJson(Map<String, dynamic> json) =>
        _$_DisableAllNotificationSettingsArgs(
          weeklySignup: json['weekly_signup'] as bool? ?? false,
          newFeatures: json['new_features'] as bool? ?? false,
          community: json['community'] as bool? ?? false,
          matchProposal: json['match_proposal'] as bool? ?? false,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$_DisableAllNotificationSettingsArgsToJson(
        _$_DisableAllNotificationSettingsArgs instance) =>
    <String, dynamic>{
      'weekly_signup': instance.weeklySignup,
      'new_features': instance.newFeatures,
      'community': instance.community,
      'match_proposal': instance.matchProposal,
      'runtimeType': instance.$type,
    };

_$_UpdateNotificationSettingsArgs _$$_UpdateNotificationSettingsArgsFromJson(
        Map<String, dynamic> json) =>
    _$_UpdateNotificationSettingsArgs(
      weeklySignup: json['weekly_signup'] as bool,
      newFeatures: json['new_features'] as bool,
      community: json['community'] as bool,
      matchProposal: json['match_proposal'] as bool,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$_UpdateNotificationSettingsArgsToJson(
        _$_UpdateNotificationSettingsArgs instance) =>
    <String, dynamic>{
      'weekly_signup': instance.weeklySignup,
      'new_features': instance.newFeatures,
      'community': instance.community,
      'match_proposal': instance.matchProposal,
      'runtimeType': instance.$type,
    };
