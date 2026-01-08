// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Drop _$DropFromJson(Map<String, dynamic> json) {
  return _Drop.fromJson(json);
}

/// @nodoc
mixin _$Drop {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get domain => throw _privateConstructorUsedError;
  String get difficulty => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_limit_minutes')
  int get timeLimitMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'reward_xp')
  int get rewardXp => throw _privateConstructorUsedError;
  @JsonKey(name: 'inputs_url')
  String? get inputsUrl => throw _privateConstructorUsedError;

  /// Serializes this Drop to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Drop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DropCopyWith<Drop> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DropCopyWith<$Res> {
  factory $DropCopyWith(Drop value, $Res Function(Drop) then) =
      _$DropCopyWithImpl<$Res, Drop>;
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      String domain,
      String difficulty,
      @JsonKey(name: 'time_limit_minutes') int timeLimitMinutes,
      @JsonKey(name: 'reward_xp') int rewardXp,
      @JsonKey(name: 'inputs_url') String? inputsUrl});
}

/// @nodoc
class _$DropCopyWithImpl<$Res, $Val extends Drop>
    implements $DropCopyWith<$Res> {
  _$DropCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Drop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? domain = null,
    Object? difficulty = null,
    Object? timeLimitMinutes = null,
    Object? rewardXp = null,
    Object? inputsUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      domain: null == domain
          ? _value.domain
          : domain // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String,
      timeLimitMinutes: null == timeLimitMinutes
          ? _value.timeLimitMinutes
          : timeLimitMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      rewardXp: null == rewardXp
          ? _value.rewardXp
          : rewardXp // ignore: cast_nullable_to_non_nullable
              as int,
      inputsUrl: freezed == inputsUrl
          ? _value.inputsUrl
          : inputsUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DropImplCopyWith<$Res> implements $DropCopyWith<$Res> {
  factory _$$DropImplCopyWith(
          _$DropImpl value, $Res Function(_$DropImpl) then) =
      __$$DropImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      String domain,
      String difficulty,
      @JsonKey(name: 'time_limit_minutes') int timeLimitMinutes,
      @JsonKey(name: 'reward_xp') int rewardXp,
      @JsonKey(name: 'inputs_url') String? inputsUrl});
}

/// @nodoc
class __$$DropImplCopyWithImpl<$Res>
    extends _$DropCopyWithImpl<$Res, _$DropImpl>
    implements _$$DropImplCopyWith<$Res> {
  __$$DropImplCopyWithImpl(_$DropImpl _value, $Res Function(_$DropImpl) _then)
      : super(_value, _then);

  /// Create a copy of Drop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? domain = null,
    Object? difficulty = null,
    Object? timeLimitMinutes = null,
    Object? rewardXp = null,
    Object? inputsUrl = freezed,
  }) {
    return _then(_$DropImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      domain: null == domain
          ? _value.domain
          : domain // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String,
      timeLimitMinutes: null == timeLimitMinutes
          ? _value.timeLimitMinutes
          : timeLimitMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      rewardXp: null == rewardXp
          ? _value.rewardXp
          : rewardXp // ignore: cast_nullable_to_non_nullable
              as int,
      inputsUrl: freezed == inputsUrl
          ? _value.inputsUrl
          : inputsUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DropImpl implements _Drop {
  const _$DropImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.domain,
      required this.difficulty,
      @JsonKey(name: 'time_limit_minutes') required this.timeLimitMinutes,
      @JsonKey(name: 'reward_xp') required this.rewardXp,
      @JsonKey(name: 'inputs_url') this.inputsUrl});

  factory _$DropImpl.fromJson(Map<String, dynamic> json) =>
      _$$DropImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String domain;
  @override
  final String difficulty;
  @override
  @JsonKey(name: 'time_limit_minutes')
  final int timeLimitMinutes;
  @override
  @JsonKey(name: 'reward_xp')
  final int rewardXp;
  @override
  @JsonKey(name: 'inputs_url')
  final String? inputsUrl;

  @override
  String toString() {
    return 'Drop(id: $id, title: $title, description: $description, domain: $domain, difficulty: $difficulty, timeLimitMinutes: $timeLimitMinutes, rewardXp: $rewardXp, inputsUrl: $inputsUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DropImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.domain, domain) || other.domain == domain) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.timeLimitMinutes, timeLimitMinutes) ||
                other.timeLimitMinutes == timeLimitMinutes) &&
            (identical(other.rewardXp, rewardXp) ||
                other.rewardXp == rewardXp) &&
            (identical(other.inputsUrl, inputsUrl) ||
                other.inputsUrl == inputsUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, domain,
      difficulty, timeLimitMinutes, rewardXp, inputsUrl);

  /// Create a copy of Drop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DropImplCopyWith<_$DropImpl> get copyWith =>
      __$$DropImplCopyWithImpl<_$DropImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DropImplToJson(
      this,
    );
  }
}

abstract class _Drop implements Drop {
  const factory _Drop(
      {required final int id,
      required final String title,
      required final String description,
      required final String domain,
      required final String difficulty,
      @JsonKey(name: 'time_limit_minutes') required final int timeLimitMinutes,
      @JsonKey(name: 'reward_xp') required final int rewardXp,
      @JsonKey(name: 'inputs_url') final String? inputsUrl}) = _$DropImpl;

  factory _Drop.fromJson(Map<String, dynamic> json) = _$DropImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get domain;
  @override
  String get difficulty;
  @override
  @JsonKey(name: 'time_limit_minutes')
  int get timeLimitMinutes;
  @override
  @JsonKey(name: 'reward_xp')
  int get rewardXp;
  @override
  @JsonKey(name: 'inputs_url')
  String? get inputsUrl;

  /// Create a copy of Drop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DropImplCopyWith<_$DropImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
