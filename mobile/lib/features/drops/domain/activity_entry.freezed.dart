// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ActivityEntry _$ActivityEntryFromJson(Map<String, dynamic> json) {
  return _ActivityEntry.fromJson(json);
}

/// @nodoc
mixin _$ActivityEntry {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_name')
  String? get userName => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_avatar')
  String? get userAvatar => throw _privateConstructorUsedError;
  @JsonKey(name: 'drop_title')
  String get dropTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'drop_domain')
  String? get dropDomain => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'xp_earned')
  int get xpEarned => throw _privateConstructorUsedError;

  /// Serializes this ActivityEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityEntryCopyWith<ActivityEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityEntryCopyWith<$Res> {
  factory $ActivityEntryCopyWith(
          ActivityEntry value, $Res Function(ActivityEntry) then) =
      _$ActivityEntryCopyWithImpl<$Res, ActivityEntry>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'user_name') String? userName,
      @JsonKey(name: 'user_avatar') String? userAvatar,
      @JsonKey(name: 'drop_title') String dropTitle,
      @JsonKey(name: 'drop_domain') String? dropDomain,
      @JsonKey(name: 'completed_at') DateTime completedAt,
      @JsonKey(name: 'xp_earned') int xpEarned});
}

/// @nodoc
class _$ActivityEntryCopyWithImpl<$Res, $Val extends ActivityEntry>
    implements $ActivityEntryCopyWith<$Res> {
  _$ActivityEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = freezed,
    Object? userAvatar = freezed,
    Object? dropTitle = null,
    Object? dropDomain = freezed,
    Object? completedAt = null,
    Object? xpEarned = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      dropTitle: null == dropTitle
          ? _value.dropTitle
          : dropTitle // ignore: cast_nullable_to_non_nullable
              as String,
      dropDomain: freezed == dropDomain
          ? _value.dropDomain
          : dropDomain // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      xpEarned: null == xpEarned
          ? _value.xpEarned
          : xpEarned // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityEntryImplCopyWith<$Res>
    implements $ActivityEntryCopyWith<$Res> {
  factory _$$ActivityEntryImplCopyWith(
          _$ActivityEntryImpl value, $Res Function(_$ActivityEntryImpl) then) =
      __$$ActivityEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'user_name') String? userName,
      @JsonKey(name: 'user_avatar') String? userAvatar,
      @JsonKey(name: 'drop_title') String dropTitle,
      @JsonKey(name: 'drop_domain') String? dropDomain,
      @JsonKey(name: 'completed_at') DateTime completedAt,
      @JsonKey(name: 'xp_earned') int xpEarned});
}

/// @nodoc
class __$$ActivityEntryImplCopyWithImpl<$Res>
    extends _$ActivityEntryCopyWithImpl<$Res, _$ActivityEntryImpl>
    implements _$$ActivityEntryImplCopyWith<$Res> {
  __$$ActivityEntryImplCopyWithImpl(
      _$ActivityEntryImpl _value, $Res Function(_$ActivityEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivityEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = freezed,
    Object? userAvatar = freezed,
    Object? dropTitle = null,
    Object? dropDomain = freezed,
    Object? completedAt = null,
    Object? xpEarned = null,
  }) {
    return _then(_$ActivityEntryImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      dropTitle: null == dropTitle
          ? _value.dropTitle
          : dropTitle // ignore: cast_nullable_to_non_nullable
              as String,
      dropDomain: freezed == dropDomain
          ? _value.dropDomain
          : dropDomain // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      xpEarned: null == xpEarned
          ? _value.xpEarned
          : xpEarned // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityEntryImpl implements _ActivityEntry {
  const _$ActivityEntryImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'user_name') this.userName,
      @JsonKey(name: 'user_avatar') this.userAvatar,
      @JsonKey(name: 'drop_title') required this.dropTitle,
      @JsonKey(name: 'drop_domain') this.dropDomain,
      @JsonKey(name: 'completed_at') required this.completedAt,
      @JsonKey(name: 'xp_earned') required this.xpEarned});

  factory _$ActivityEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityEntryImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'user_name')
  final String? userName;
  @override
  @JsonKey(name: 'user_avatar')
  final String? userAvatar;
  @override
  @JsonKey(name: 'drop_title')
  final String dropTitle;
  @override
  @JsonKey(name: 'drop_domain')
  final String? dropDomain;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime completedAt;
  @override
  @JsonKey(name: 'xp_earned')
  final int xpEarned;

  @override
  String toString() {
    return 'ActivityEntry(userId: $userId, userName: $userName, userAvatar: $userAvatar, dropTitle: $dropTitle, dropDomain: $dropDomain, completedAt: $completedAt, xpEarned: $xpEarned)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityEntryImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.dropTitle, dropTitle) ||
                other.dropTitle == dropTitle) &&
            (identical(other.dropDomain, dropDomain) ||
                other.dropDomain == dropDomain) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.xpEarned, xpEarned) ||
                other.xpEarned == xpEarned));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, userName, userAvatar,
      dropTitle, dropDomain, completedAt, xpEarned);

  /// Create a copy of ActivityEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityEntryImplCopyWith<_$ActivityEntryImpl> get copyWith =>
      __$$ActivityEntryImplCopyWithImpl<_$ActivityEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityEntryImplToJson(
      this,
    );
  }
}

abstract class _ActivityEntry implements ActivityEntry {
  const factory _ActivityEntry(
          {@JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'user_name') final String? userName,
          @JsonKey(name: 'user_avatar') final String? userAvatar,
          @JsonKey(name: 'drop_title') required final String dropTitle,
          @JsonKey(name: 'drop_domain') final String? dropDomain,
          @JsonKey(name: 'completed_at') required final DateTime completedAt,
          @JsonKey(name: 'xp_earned') required final int xpEarned}) =
      _$ActivityEntryImpl;

  factory _ActivityEntry.fromJson(Map<String, dynamic> json) =
      _$ActivityEntryImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'user_name')
  String? get userName;
  @override
  @JsonKey(name: 'user_avatar')
  String? get userAvatar;
  @override
  @JsonKey(name: 'drop_title')
  String get dropTitle;
  @override
  @JsonKey(name: 'drop_domain')
  String? get dropDomain;
  @override
  @JsonKey(name: 'completed_at')
  DateTime get completedAt;
  @override
  @JsonKey(name: 'xp_earned')
  int get xpEarned;

  /// Create a copy of ActivityEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityEntryImplCopyWith<_$ActivityEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
