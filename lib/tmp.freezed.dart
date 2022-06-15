// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'tmp.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UpdateNotificationSettingsArgs _$UpdateNotificationSettingsArgsFromJson(
    Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'disableAll':
      return _DisableAllNotificationSettingsArgs.fromJson(json);
    case 'default':
      return _UpdateNotificationSettingsArgs.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json,
          'runtimeType',
          'UpdateNotificationSettingsArgs',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
class _$UpdateNotificationSettingsArgsTearOff {
  const _$UpdateNotificationSettingsArgsTearOff();

  _DisableAllNotificationSettingsArgs disableAll(
      {@JsonKey(name: 'weekly_signup') bool weeklySignup = false,
      @JsonKey(name: 'new_features') bool newFeatures = false,
      @JsonKey(name: 'community') bool community = false,
      @JsonKey(name: 'match_proposal') bool matchProposal = false}) {
    return _DisableAllNotificationSettingsArgs(
      weeklySignup: weeklySignup,
      newFeatures: newFeatures,
      community: community,
      matchProposal: matchProposal,
    );
  }

  _UpdateNotificationSettingsArgs call(
      {@JsonKey(name: 'weekly_signup') required bool weeklySignup,
      @JsonKey(name: 'new_features') required bool newFeatures,
      @JsonKey(name: 'community') required bool community,
      @JsonKey(name: 'match_proposal') required bool matchProposal}) {
    return _UpdateNotificationSettingsArgs(
      weeklySignup: weeklySignup,
      newFeatures: newFeatures,
      community: community,
      matchProposal: matchProposal,
    );
  }

  UpdateNotificationSettingsArgs fromJson(Map<String, Object?> json) {
    return UpdateNotificationSettingsArgs.fromJson(json);
  }
}

/// @nodoc
const $UpdateNotificationSettingsArgs =
    _$UpdateNotificationSettingsArgsTearOff();

/// @nodoc
mixin _$UpdateNotificationSettingsArgs {
  @JsonKey(name: 'weekly_signup')
  bool get weeklySignup => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_features')
  bool get newFeatures => throw _privateConstructorUsedError;
  @JsonKey(name: 'community')
  bool get community => throw _privateConstructorUsedError;
  @JsonKey(name: 'match_proposal')
  bool get matchProposal => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)
        $default, {
    required TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)
        disableAll,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)?
        $default, {
    TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)?
        disableAll,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)?
        $default, {
    TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)?
        disableAll,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UpdateNotificationSettingsArgs value) $default, {
    required TResult Function(_DisableAllNotificationSettingsArgs value)
        disableAll,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(_UpdateNotificationSettingsArgs value)? $default, {
    TResult Function(_DisableAllNotificationSettingsArgs value)? disableAll,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UpdateNotificationSettingsArgs value)? $default, {
    TResult Function(_DisableAllNotificationSettingsArgs value)? disableAll,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdateNotificationSettingsArgsCopyWith<UpdateNotificationSettingsArgs>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateNotificationSettingsArgsCopyWith<$Res> {
  factory $UpdateNotificationSettingsArgsCopyWith(
          UpdateNotificationSettingsArgs value,
          $Res Function(UpdateNotificationSettingsArgs) then) =
      _$UpdateNotificationSettingsArgsCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: 'weekly_signup') bool weeklySignup,
      @JsonKey(name: 'new_features') bool newFeatures,
      @JsonKey(name: 'community') bool community,
      @JsonKey(name: 'match_proposal') bool matchProposal});
}

/// @nodoc
class _$UpdateNotificationSettingsArgsCopyWithImpl<$Res>
    implements $UpdateNotificationSettingsArgsCopyWith<$Res> {
  _$UpdateNotificationSettingsArgsCopyWithImpl(this._value, this._then);

  final UpdateNotificationSettingsArgs _value;
  // ignore: unused_field
  final $Res Function(UpdateNotificationSettingsArgs) _then;

  @override
  $Res call({
    Object? weeklySignup = freezed,
    Object? newFeatures = freezed,
    Object? community = freezed,
    Object? matchProposal = freezed,
  }) {
    return _then(_value.copyWith(
      weeklySignup: weeklySignup == freezed
          ? _value.weeklySignup
          : weeklySignup // ignore: cast_nullable_to_non_nullable
              as bool,
      newFeatures: newFeatures == freezed
          ? _value.newFeatures
          : newFeatures // ignore: cast_nullable_to_non_nullable
              as bool,
      community: community == freezed
          ? _value.community
          : community // ignore: cast_nullable_to_non_nullable
              as bool,
      matchProposal: matchProposal == freezed
          ? _value.matchProposal
          : matchProposal // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$DisableAllNotificationSettingsArgsCopyWith<$Res>
    implements $UpdateNotificationSettingsArgsCopyWith<$Res> {
  factory _$DisableAllNotificationSettingsArgsCopyWith(
          _DisableAllNotificationSettingsArgs value,
          $Res Function(_DisableAllNotificationSettingsArgs) then) =
      __$DisableAllNotificationSettingsArgsCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: 'weekly_signup') bool weeklySignup,
      @JsonKey(name: 'new_features') bool newFeatures,
      @JsonKey(name: 'community') bool community,
      @JsonKey(name: 'match_proposal') bool matchProposal});
}

/// @nodoc
class __$DisableAllNotificationSettingsArgsCopyWithImpl<$Res>
    extends _$UpdateNotificationSettingsArgsCopyWithImpl<$Res>
    implements _$DisableAllNotificationSettingsArgsCopyWith<$Res> {
  __$DisableAllNotificationSettingsArgsCopyWithImpl(
      _DisableAllNotificationSettingsArgs _value,
      $Res Function(_DisableAllNotificationSettingsArgs) _then)
      : super(_value, (v) => _then(v as _DisableAllNotificationSettingsArgs));

  @override
  _DisableAllNotificationSettingsArgs get _value =>
      super._value as _DisableAllNotificationSettingsArgs;

  @override
  $Res call({
    Object? weeklySignup = freezed,
    Object? newFeatures = freezed,
    Object? community = freezed,
    Object? matchProposal = freezed,
  }) {
    return _then(_DisableAllNotificationSettingsArgs(
      weeklySignup: weeklySignup == freezed
          ? _value.weeklySignup
          : weeklySignup // ignore: cast_nullable_to_non_nullable
              as bool,
      newFeatures: newFeatures == freezed
          ? _value.newFeatures
          : newFeatures // ignore: cast_nullable_to_non_nullable
              as bool,
      community: community == freezed
          ? _value.community
          : community // ignore: cast_nullable_to_non_nullable
              as bool,
      matchProposal: matchProposal == freezed
          ? _value.matchProposal
          : matchProposal // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_DisableAllNotificationSettingsArgs
    implements _DisableAllNotificationSettingsArgs {
  _$_DisableAllNotificationSettingsArgs(
      {@JsonKey(name: 'weekly_signup') this.weeklySignup = false,
      @JsonKey(name: 'new_features') this.newFeatures = false,
      @JsonKey(name: 'community') this.community = false,
      @JsonKey(name: 'match_proposal') this.matchProposal = false,
      String? $type})
      : $type = $type ?? 'disableAll';

  factory _$_DisableAllNotificationSettingsArgs.fromJson(
          Map<String, dynamic> json) =>
      _$$_DisableAllNotificationSettingsArgsFromJson(json);

  @override
  @JsonKey(name: 'weekly_signup')
  final bool weeklySignup;
  @override
  @JsonKey(name: 'new_features')
  final bool newFeatures;
  @override
  @JsonKey(name: 'community')
  final bool community;
  @override
  @JsonKey(name: 'match_proposal')
  final bool matchProposal;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'UpdateNotificationSettingsArgs.disableAll(weeklySignup: $weeklySignup, newFeatures: $newFeatures, community: $community, matchProposal: $matchProposal)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DisableAllNotificationSettingsArgs &&
            const DeepCollectionEquality()
                .equals(other.weeklySignup, weeklySignup) &&
            const DeepCollectionEquality()
                .equals(other.newFeatures, newFeatures) &&
            const DeepCollectionEquality().equals(other.community, community) &&
            const DeepCollectionEquality()
                .equals(other.matchProposal, matchProposal));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(weeklySignup),
      const DeepCollectionEquality().hash(newFeatures),
      const DeepCollectionEquality().hash(community),
      const DeepCollectionEquality().hash(matchProposal));

  @JsonKey(ignore: true)
  @override
  _$DisableAllNotificationSettingsArgsCopyWith<
          _DisableAllNotificationSettingsArgs>
      get copyWith => __$DisableAllNotificationSettingsArgsCopyWithImpl<
          _DisableAllNotificationSettingsArgs>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)
        $default, {
    required TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)
        disableAll,
  }) {
    return disableAll(weeklySignup, newFeatures, community, matchProposal);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)?
        $default, {
    TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)?
        disableAll,
  }) {
    return disableAll?.call(
        weeklySignup, newFeatures, community, matchProposal);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)?
        $default, {
    TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)?
        disableAll,
    required TResult orElse(),
  }) {
    if (disableAll != null) {
      return disableAll(weeklySignup, newFeatures, community, matchProposal);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UpdateNotificationSettingsArgs value) $default, {
    required TResult Function(_DisableAllNotificationSettingsArgs value)
        disableAll,
  }) {
    return disableAll(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(_UpdateNotificationSettingsArgs value)? $default, {
    TResult Function(_DisableAllNotificationSettingsArgs value)? disableAll,
  }) {
    return disableAll?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UpdateNotificationSettingsArgs value)? $default, {
    TResult Function(_DisableAllNotificationSettingsArgs value)? disableAll,
    required TResult orElse(),
  }) {
    if (disableAll != null) {
      return disableAll(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_DisableAllNotificationSettingsArgsToJson(this);
  }
}

abstract class _DisableAllNotificationSettingsArgs
    implements UpdateNotificationSettingsArgs {
  factory _DisableAllNotificationSettingsArgs(
          {@JsonKey(name: 'weekly_signup') bool weeklySignup,
          @JsonKey(name: 'new_features') bool newFeatures,
          @JsonKey(name: 'community') bool community,
          @JsonKey(name: 'match_proposal') bool matchProposal}) =
      _$_DisableAllNotificationSettingsArgs;

  factory _DisableAllNotificationSettingsArgs.fromJson(
          Map<String, dynamic> json) =
      _$_DisableAllNotificationSettingsArgs.fromJson;

  @override
  @JsonKey(name: 'weekly_signup')
  bool get weeklySignup;
  @override
  @JsonKey(name: 'new_features')
  bool get newFeatures;
  @override
  @JsonKey(name: 'community')
  bool get community;
  @override
  @JsonKey(name: 'match_proposal')
  bool get matchProposal;
  @override
  @JsonKey(ignore: true)
  _$DisableAllNotificationSettingsArgsCopyWith<
          _DisableAllNotificationSettingsArgs>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$UpdateNotificationSettingsArgsCopyWith<$Res>
    implements $UpdateNotificationSettingsArgsCopyWith<$Res> {
  factory _$UpdateNotificationSettingsArgsCopyWith(
          _UpdateNotificationSettingsArgs value,
          $Res Function(_UpdateNotificationSettingsArgs) then) =
      __$UpdateNotificationSettingsArgsCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: 'weekly_signup') bool weeklySignup,
      @JsonKey(name: 'new_features') bool newFeatures,
      @JsonKey(name: 'community') bool community,
      @JsonKey(name: 'match_proposal') bool matchProposal});
}

/// @nodoc
class __$UpdateNotificationSettingsArgsCopyWithImpl<$Res>
    extends _$UpdateNotificationSettingsArgsCopyWithImpl<$Res>
    implements _$UpdateNotificationSettingsArgsCopyWith<$Res> {
  __$UpdateNotificationSettingsArgsCopyWithImpl(
      _UpdateNotificationSettingsArgs _value,
      $Res Function(_UpdateNotificationSettingsArgs) _then)
      : super(_value, (v) => _then(v as _UpdateNotificationSettingsArgs));

  @override
  _UpdateNotificationSettingsArgs get _value =>
      super._value as _UpdateNotificationSettingsArgs;

  @override
  $Res call({
    Object? weeklySignup = freezed,
    Object? newFeatures = freezed,
    Object? community = freezed,
    Object? matchProposal = freezed,
  }) {
    return _then(_UpdateNotificationSettingsArgs(
      weeklySignup: weeklySignup == freezed
          ? _value.weeklySignup
          : weeklySignup // ignore: cast_nullable_to_non_nullable
              as bool,
      newFeatures: newFeatures == freezed
          ? _value.newFeatures
          : newFeatures // ignore: cast_nullable_to_non_nullable
              as bool,
      community: community == freezed
          ? _value.community
          : community // ignore: cast_nullable_to_non_nullable
              as bool,
      matchProposal: matchProposal == freezed
          ? _value.matchProposal
          : matchProposal // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UpdateNotificationSettingsArgs
    implements _UpdateNotificationSettingsArgs {
  _$_UpdateNotificationSettingsArgs(
      {@JsonKey(name: 'weekly_signup') required this.weeklySignup,
      @JsonKey(name: 'new_features') required this.newFeatures,
      @JsonKey(name: 'community') required this.community,
      @JsonKey(name: 'match_proposal') required this.matchProposal,
      String? $type})
      : $type = $type ?? 'default';

  factory _$_UpdateNotificationSettingsArgs.fromJson(
          Map<String, dynamic> json) =>
      _$$_UpdateNotificationSettingsArgsFromJson(json);

  @override
  @JsonKey(name: 'weekly_signup')
  final bool weeklySignup;
  @override
  @JsonKey(name: 'new_features')
  final bool newFeatures;
  @override
  @JsonKey(name: 'community')
  final bool community;
  @override
  @JsonKey(name: 'match_proposal')
  final bool matchProposal;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'UpdateNotificationSettingsArgs(weeklySignup: $weeklySignup, newFeatures: $newFeatures, community: $community, matchProposal: $matchProposal)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UpdateNotificationSettingsArgs &&
            const DeepCollectionEquality()
                .equals(other.weeklySignup, weeklySignup) &&
            const DeepCollectionEquality()
                .equals(other.newFeatures, newFeatures) &&
            const DeepCollectionEquality().equals(other.community, community) &&
            const DeepCollectionEquality()
                .equals(other.matchProposal, matchProposal));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(weeklySignup),
      const DeepCollectionEquality().hash(newFeatures),
      const DeepCollectionEquality().hash(community),
      const DeepCollectionEquality().hash(matchProposal));

  @JsonKey(ignore: true)
  @override
  _$UpdateNotificationSettingsArgsCopyWith<_UpdateNotificationSettingsArgs>
      get copyWith => __$UpdateNotificationSettingsArgsCopyWithImpl<
          _UpdateNotificationSettingsArgs>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)
        $default, {
    required TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)
        disableAll,
  }) {
    return $default(weeklySignup, newFeatures, community, matchProposal);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)?
        $default, {
    TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)?
        disableAll,
  }) {
    return $default?.call(weeklySignup, newFeatures, community, matchProposal);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)?
        $default, {
    TResult Function(
            @JsonKey(name: 'weekly_signup') bool weeklySignup,
            @JsonKey(name: 'new_features') bool newFeatures,
            @JsonKey(name: 'community') bool community,
            @JsonKey(name: 'match_proposal') bool matchProposal)?
        disableAll,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(weeklySignup, newFeatures, community, matchProposal);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UpdateNotificationSettingsArgs value) $default, {
    required TResult Function(_DisableAllNotificationSettingsArgs value)
        disableAll,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(_UpdateNotificationSettingsArgs value)? $default, {
    TResult Function(_DisableAllNotificationSettingsArgs value)? disableAll,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UpdateNotificationSettingsArgs value)? $default, {
    TResult Function(_DisableAllNotificationSettingsArgs value)? disableAll,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_UpdateNotificationSettingsArgsToJson(this);
  }
}

abstract class _UpdateNotificationSettingsArgs
    implements UpdateNotificationSettingsArgs {
  factory _UpdateNotificationSettingsArgs(
          {@JsonKey(name: 'weekly_signup') required bool weeklySignup,
          @JsonKey(name: 'new_features') required bool newFeatures,
          @JsonKey(name: 'community') required bool community,
          @JsonKey(name: 'match_proposal') required bool matchProposal}) =
      _$_UpdateNotificationSettingsArgs;

  factory _UpdateNotificationSettingsArgs.fromJson(Map<String, dynamic> json) =
      _$_UpdateNotificationSettingsArgs.fromJson;

  @override
  @JsonKey(name: 'weekly_signup')
  bool get weeklySignup;
  @override
  @JsonKey(name: 'new_features')
  bool get newFeatures;
  @override
  @JsonKey(name: 'community')
  bool get community;
  @override
  @JsonKey(name: 'match_proposal')
  bool get matchProposal;
  @override
  @JsonKey(ignore: true)
  _$UpdateNotificationSettingsArgsCopyWith<_UpdateNotificationSettingsArgs>
      get copyWith => throw _privateConstructorUsedError;
}
