// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DropImpl _$$DropImplFromJson(Map<String, dynamic> json) => _$DropImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      domain: json['domain'] as String,
      difficulty: json['difficulty'] as String,
      timeLimitMinutes: (json['time_limit_minutes'] as num).toInt(),
      rewardXp: (json['reward_xp'] as num).toInt(),
      inputsUrl: json['inputs_url'] as String?,
      sourceUrl: json['source_url'] as String?,
      sourceType: json['source_type'] as String? ?? 'A',
      submissionType: json['submission_type'] as String? ?? 'code',
    );

Map<String, dynamic> _$$DropImplToJson(_$DropImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'domain': instance.domain,
      'difficulty': instance.difficulty,
      'time_limit_minutes': instance.timeLimitMinutes,
      'reward_xp': instance.rewardXp,
      'inputs_url': instance.inputsUrl,
      'source_url': instance.sourceUrl,
      'source_type': instance.sourceType,
      'submission_type': instance.submissionType,
    };
