// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
      {@JsonKey(name: 'total_xp') this.totalXp = 0,
      this.level = 1,
      @JsonKey(name: 'completed_drops') this.completedDrops = 0,
      this.rank = 'Novice',
      @JsonKey(name: 'xp_breakdown')
      final Map<String, dynamic> xpBreakdown = const {}})
      : _xpBreakdown = xpBreakdown;

  factory _$UserStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_xp')
  final int totalXp;
  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey(name: 'completed_drops')
  final int completedDrops;
  @override
  @JsonKey()
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
      {@JsonKey(name: 'total_xp') final int totalXp,
      final int level,
      @JsonKey(name: 'completed_drops') final int completedDrops,
      final String rank,
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
