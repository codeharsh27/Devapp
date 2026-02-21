// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String? get fullName => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'social_links')
  Map<String, dynamic> get socialLinks => throw _privateConstructorUsedError;
  @JsonKey(name: 'upi_id')
  String? get upiId => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_xp')
  int get totalXp => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  @JsonKey(name: 'xp_breakdown')
  Map<String, dynamic> get xpBreakdown => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String id,
      String email,
      @JsonKey(name: 'full_name') String? fullName,
      String? bio,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'social_links') Map<String, dynamic> socialLinks,
      @JsonKey(name: 'upi_id') String? upiId,
      @JsonKey(name: 'total_xp') int totalXp,
      int level,
      @JsonKey(name: 'xp_breakdown') Map<String, dynamic> xpBreakdown});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = freezed,
    Object? bio = freezed,
    Object? avatarUrl = freezed,
    Object? socialLinks = null,
    Object? upiId = freezed,
    Object? totalXp = null,
    Object? level = null,
    Object? xpBreakdown = null,
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
      socialLinks: null == socialLinks
          ? _value.socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      upiId: freezed == upiId
          ? _value.upiId
          : upiId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalXp: null == totalXp
          ? _value.totalXp
          : totalXp // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      xpBreakdown: null == xpBreakdown
          ? _value.xpBreakdown
          : xpBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      @JsonKey(name: 'full_name') String? fullName,
      String? bio,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'social_links') Map<String, dynamic> socialLinks,
      @JsonKey(name: 'upi_id') String? upiId,
      @JsonKey(name: 'total_xp') int totalXp,
      int level,
      @JsonKey(name: 'xp_breakdown') Map<String, dynamic> xpBreakdown});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = freezed,
    Object? bio = freezed,
    Object? avatarUrl = freezed,
    Object? socialLinks = null,
    Object? upiId = freezed,
    Object? totalXp = null,
    Object? level = null,
    Object? xpBreakdown = null,
  }) {
    return _then(_$UserProfileImpl(
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
      socialLinks: null == socialLinks
          ? _value._socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      upiId: freezed == upiId
          ? _value.upiId
          : upiId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalXp: null == totalXp
          ? _value.totalXp
          : totalXp // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      xpBreakdown: null == xpBreakdown
          ? _value._xpBreakdown
          : xpBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {required this.id,
      required this.email,
      @JsonKey(name: 'full_name') this.fullName,
      this.bio,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'social_links')
      final Map<String, dynamic> socialLinks = const {},
      @JsonKey(name: 'upi_id') this.upiId,
      @JsonKey(name: 'total_xp') this.totalXp = 0,
      this.level = 1,
      @JsonKey(name: 'xp_breakdown')
      final Map<String, dynamic> xpBreakdown = const {}})
      : _socialLinks = socialLinks,
        _xpBreakdown = xpBreakdown;

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

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
  final Map<String, dynamic> _socialLinks;
  @override
  @JsonKey(name: 'social_links')
  Map<String, dynamic> get socialLinks {
    if (_socialLinks is EqualUnmodifiableMapView) return _socialLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_socialLinks);
  }

  @override
  @JsonKey(name: 'upi_id')
  final String? upiId;
  @override
  @JsonKey(name: 'total_xp')
  final int totalXp;
  @override
  @JsonKey()
  final int level;
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
    return 'UserProfile(id: $id, email: $email, fullName: $fullName, bio: $bio, avatarUrl: $avatarUrl, socialLinks: $socialLinks, upiId: $upiId, totalXp: $totalXp, level: $level, xpBreakdown: $xpBreakdown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            const DeepCollectionEquality()
                .equals(other._socialLinks, _socialLinks) &&
            (identical(other.upiId, upiId) || other.upiId == upiId) &&
            (identical(other.totalXp, totalXp) || other.totalXp == totalXp) &&
            (identical(other.level, level) || other.level == level) &&
            const DeepCollectionEquality()
                .equals(other._xpBreakdown, _xpBreakdown));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      fullName,
      bio,
      avatarUrl,
      const DeepCollectionEquality().hash(_socialLinks),
      upiId,
      totalXp,
      level,
      const DeepCollectionEquality().hash(_xpBreakdown));

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {required final String id,
      required final String email,
      @JsonKey(name: 'full_name') final String? fullName,
      final String? bio,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      @JsonKey(name: 'social_links') final Map<String, dynamic> socialLinks,
      @JsonKey(name: 'upi_id') final String? upiId,
      @JsonKey(name: 'total_xp') final int totalXp,
      final int level,
      @JsonKey(name: 'xp_breakdown')
      final Map<String, dynamic> xpBreakdown}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

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
  @JsonKey(name: 'social_links')
  Map<String, dynamic> get socialLinks;
  @override
  @JsonKey(name: 'upi_id')
  String? get upiId;
  @override
  @JsonKey(name: 'total_xp')
  int get totalXp;
  @override
  int get level;
  @override
  @JsonKey(name: 'xp_breakdown')
  Map<String, dynamic> get xpBreakdown;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
