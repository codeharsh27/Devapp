// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      socialLinks: json['social_links'] as Map<String, dynamic>? ?? const {},
      upiId: json['upi_id'] as String?,
      totalXp: (json['total_xp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      xpBreakdown: json['xp_breakdown'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.fullName,
      'bio': instance.bio,
      'avatar_url': instance.avatarUrl,
      'social_links': instance.socialLinks,
      'upi_id': instance.upiId,
      'total_xp': instance.totalXp,
      'level': instance.level,
      'xp_breakdown': instance.xpBreakdown,
    };
