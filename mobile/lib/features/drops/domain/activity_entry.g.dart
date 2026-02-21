// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityEntryImpl _$$ActivityEntryImplFromJson(Map<String, dynamic> json) =>
    _$ActivityEntryImpl(
      userId: json['user_id'] as String,
      userName: json['user_name'] as String?,
      userAvatar: json['user_avatar'] as String?,
      dropTitle: json['drop_title'] as String,
      dropDomain: json['drop_domain'] as String?,
      completedAt: DateTime.parse(json['completed_at'] as String),
      xpEarned: (json['xp_earned'] as num).toInt(),
    );

Map<String, dynamic> _$$ActivityEntryImplToJson(_$ActivityEntryImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'user_avatar': instance.userAvatar,
      'drop_title': instance.dropTitle,
      'drop_domain': instance.dropDomain,
      'completed_at': instance.completedAt.toIso8601String(),
      'xp_earned': instance.xpEarned,
    };
