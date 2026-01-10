import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats.freezed.dart';
part 'user_stats.g.dart';

@freezed
class UserStats with _$UserStats {
  const factory UserStats({
    @Default(0) @JsonKey(name: 'total_xp') int totalXp,
    @Default(1) int level,
    @Default(0) @JsonKey(name: 'completed_drops') int completedDrops,
    @Default('Novice') String rank,
    @Default({})
    @JsonKey(name: 'xp_breakdown')
    Map<String, dynamic> xpBreakdown,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}
