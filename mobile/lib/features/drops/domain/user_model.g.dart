// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      upiId: json['upi_id'] as String?,
      socialLinks: json['social_links'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.fullName,
      'bio': instance.bio,
      'avatar_url': instance.avatarUrl,
      'upi_id': instance.upiId,
      'social_links': instance.socialLinks,
    };

_$UserStatsImpl _$$UserStatsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsImpl(
      totalXp: (json['total_xp'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      completedDrops: (json['completed_drops'] as num).toInt(),
      rank: json['rank'] as String,
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
