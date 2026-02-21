// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubmissionImpl _$$SubmissionImplFromJson(Map<String, dynamic> json) =>
    _$SubmissionImpl(
      id: (json['id'] as num).toInt(),
      dropId: (json['drop_id'] as num).toInt(),
      userId: json['user_id'] as String,
      submissionUrl: json['submission_url'] as String,
      imageUrl: json['image_url'] as String?,
      status: json['status'] as String,
      score: (json['score'] as num?)?.toInt(),
      feedback: json['feedback'] as String?,
      submittedAt: DateTime.parse(json['submitted_at'] as String),
      drop: json['drop'] == null
          ? null
          : Drop.fromJson(json['drop'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SubmissionImplToJson(_$SubmissionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'drop_id': instance.dropId,
      'user_id': instance.userId,
      'submission_url': instance.submissionUrl,
      'image_url': instance.imageUrl,
      'status': instance.status,
      'score': instance.score,
      'feedback': instance.feedback,
      'submitted_at': instance.submittedAt.toIso8601String(),
      'drop': instance.drop,
    };
