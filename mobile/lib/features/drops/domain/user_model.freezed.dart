// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String? get fullName => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'upi_id')
  String? get upiId => throw _privateConstructorUsedError;
  @JsonKey(name: 'social_links')
  Map<String, dynamic>? get socialLinks => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      String email,
      @JsonKey(name: 'full_name') String? fullName,
      String? bio,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'upi_id') String? upiId,
      @JsonKey(name: 'social_links') Map<String, dynamic>? socialLinks});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = freezed,
    Object? bio = freezed,
    Object? avatarUrl = freezed,
    Object? upiId = freezed,
    Object? socialLinks = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      upiId: freezed == upiId
          ? _value.upiId
          : upiId // ignore: cast_nullable_to_non_nullable
              as String?,
      socialLinks: freezed == socialLinks
          ? _value.socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      @JsonKey(name: 'full_name') String? fullName,
      String? bio,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'upi_id') String? upiId,
      @JsonKey(name: 'social_links') Map<String, dynamic>? socialLinks});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = freezed,
    Object? bio = freezed,
    Object? avatarUrl = freezed,
    Object? upiId = freezed,
    Object? socialLinks = freezed,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      upiId: freezed == upiId
          ? _value.upiId
          : upiId // ignore: cast_nullable_to_non_nullable
              as String?,
      socialLinks: freezed == socialLinks
          ? _value._socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.id,
      required this.email,
      @JsonKey(name: 'full_name') this.fullName,
      this.bio,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'upi_id') this.upiId,
      @JsonKey(name: 'social_links') final Map<String, dynamic>? socialLinks})
      : _socialLinks = socialLinks;

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  @JsonKey(name: 'full_name')
  final String? fullName;
  @override
  final String? bio;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'upi_id')
  final String? upiId;
  final Map<String, dynamic>? _socialLinks;
  @override
  @JsonKey(name: 'social_links')
  Map<String, dynamic>? get socialLinks {
    final value = _socialLinks;
    if (value == null) return null;
    if (_socialLinks is EqualUnmodifiableMapView) return _socialLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, fullName: $fullName, bio: $bio, avatarUrl: $avatarUrl, upiId: $upiId, socialLinks: $socialLinks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.upiId, upiId) || other.upiId == upiId) &&
            const DeepCollectionEquality()
                .equals(other._socialLinks, _socialLinks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, fullName, bio,
      avatarUrl, upiId, const DeepCollectionEquality().hash(_socialLinks));

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String id,
      required final String email,
      @JsonKey(name: 'full_name') final String? fullName,
      final String? bio,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      @JsonKey(name: 'upi_id') final String? upiId,
      @JsonKey(name: 'social_links')
      final Map<String, dynamic>? socialLinks}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  @JsonKey(name: 'full_name')
  String? get fullName;
  @override
  String? get bio;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'upi_id')
  String? get upiId;
  @override
  @JsonKey(name: 'social_links')
  Map<String, dynamic>? get socialLinks;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserStats _$UserStatsFromJson(Map<String, dynamic> json) {
  return _UserStats.fromJson(json);
}

/// @nodoc
mixin _$UserStats {
  @JsonKey(name: 'total_xp')
  int get totalXp => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_drops')
  int get completedDrops => throw _privateConstructorUsedError;
  String get rank => throw _privateConstructorUsedError;
  @JsonKey(name: 'xp_breakdown')
  Map<String, dynamic> get xpBreakdown => throw _privateConstructorUsedError;

  /// Serializes this UserStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatsCopyWith<UserStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsCopyWith<$Res> {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) then) =
      _$UserStatsCopyWithImpl<$Res, UserStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_xp') int totalXp,
      int level,
      @JsonKey(name: 'completed_drops') int completedDrops,
      String rank,
      @JsonKey(name: 'xp_breakdown') Map<String, dynamic> xpBreakdown});
}

/// @nodoc
class _$UserStatsCopyWithImpl<$Res, $Val extends UserStats>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalXp = null,
    Object? level = null,
    Object? completedDrops = null,
    Object? rank = null,
    Object? xpBreakdown = null,
  }) {
    return _then(_value.copyWith(
      totalXp: null == totalXp
          ? _value.totalXp
          : totalXp // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      completedDrops: null == completedDrops
          ? _value.completedDrops
          : completedDrops // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as String,
      xpBreakdown: null == xpBreakdown
          ? _value.xpBreakdown
          : xpBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserStatsImplCopyWith<$Res>
    implements $UserStatsCopyWith<$Res> {
  factory _$$UserStatsImplCopyWith(
          _$UserStatsImpl value, $Res Function(_$UserStatsImpl) then) =
      __$$UserStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_xp') int totalXp,
      int level,
      @JsonKey(name: 'completed_drops') int completedDrops,
      String rank,
      @JsonKey(name: 'xp_breakdown') Map<String, dynamic> xpBreakdown});
}

/// @nodoc
class __$$UserStatsImplCopyWithImpl<$Res>
    extends _$UserStatsCopyWithImpl<$Res, _$UserStatsImpl>
    implements _$$UserStatsImplCopyWith<$Res> {
  __$$UserStatsImplCopyWithImpl(
      _$UserStatsImpl _value, $Res Function(_$UserStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalXp = null,
    Object? level = null,
    Object? completedDrops = null,
    Object? rank = null,
    Object? xpBreakdown = null,
  }) {
    return _then(_$UserStatsImpl(
      totalXp: null == totalXp
          ? _value.totalXp
          : totalXp // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      completedDrops: null == completedDrops
          ? _value.completedDrops
          : completedDrops // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as String,
      xpBreakdown: null == xpBreakdown
          ? _value._xpBreakdown
          : xpBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatsImpl implements _UserStats {
  const _$UserStatsImpl(
      {@JsonKey(name: 'total_xp') required this.totalXp,
      required this.level,
      @JsonKey(name: 'completed_drops') required this.completedDrops,
      required this.rank,
      @JsonKey(name: 'xp_breakdown')
      final Map<String, dynamic> xpBreakdown = const {}})
      : _xpBreakdown = xpBreakdown;

  factory _$UserStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_xp')
  final int totalXp;
  @override
  final int level;
  @override
  @JsonKey(name: 'completed_drops')
  final int completedDrops;
  @override
  final String rank;
  final Map<String, dynamic> _xpBreakdown;
  @override
  @JsonKey(name: 'xp_breakdown')
  Map<String, dynamic> get xpBreakdown {
    if (_xpBreakdown is EqualUnmodifiableMapView) return _xpBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_xpBreakdown);
  }

  @override
  String toString() {
    return 'UserStats(totalXp: $totalXp, level: $level, completedDrops: $completedDrops, rank: $rank, xpBreakdown: $xpBreakdown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsImpl &&
            (identical(other.totalXp, totalXp) || other.totalXp == totalXp) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.completedDrops, completedDrops) ||
                other.completedDrops == completedDrops) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            const DeepCollectionEquality()
                .equals(other._xpBreakdown, _xpBreakdown));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalXp, level, completedDrops,
      rank, const DeepCollectionEquality().hash(_xpBreakdown));

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      __$$UserStatsImplCopyWithImpl<_$UserStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatsImplToJson(
      this,
    );
  }
}

abstract class _UserStats implements UserStats {
  const factory _UserStats(
      {@JsonKey(name: 'total_xp') required final int totalXp,
      required final int level,
      @JsonKey(name: 'completed_drops') required final int completedDrops,
      required final String rank,
      @JsonKey(name: 'xp_breakdown')
      final Map<String, dynamic> xpBreakdown}) = _$UserStatsImpl;

  factory _UserStats.fromJson(Map<String, dynamic> json) =
      _$UserStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_xp')
  int get totalXp;
  @override
  int get level;
  @override
  @JsonKey(name: 'completed_drops')
  int get completedDrops;
  @override
  String get rank;
  @override
  @JsonKey(name: 'xp_breakdown')
  Map<String, dynamic> get xpBreakdown;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
