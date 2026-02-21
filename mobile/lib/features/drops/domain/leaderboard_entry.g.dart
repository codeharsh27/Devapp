// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaderboardEntryImpl _$$LeaderboardEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$LeaderboardEntryImpl(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      totalXp: (json['total_xp'] as num).toInt(),
      level: (json['level'] as num).toInt(),
    );

Map<String, dynamic> _$$LeaderboardEntryImplToJson(
        _$LeaderboardEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'avatar_url': instance.avatarUrl,
      'total_xp': instance.totalXp,
      'level': instance.level,
    };
