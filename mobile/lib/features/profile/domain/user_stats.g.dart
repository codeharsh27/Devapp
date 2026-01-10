// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserStatsImpl _$$UserStatsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsImpl(
      totalXp: (json['total_xp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      completedDrops: (json['completed_drops'] as num?)?.toInt() ?? 0,
      rank: json['rank'] as String? ?? 'Novice',
      xpBreakdown: json['xp_breakdown'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$UserStatsImplToJson(_$UserStatsImpl instance) =>
    <String, dynamic>{
      'total_xp': instance.totalXp,
      'level': instance.level,
      'completed_drops': instance.completedDrops,
      'rank': instance.rank,
      'xp_breakdown': instance.xpBreakdown,
    };
