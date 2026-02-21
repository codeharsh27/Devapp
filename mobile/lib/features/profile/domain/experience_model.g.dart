// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExperienceImpl _$$ExperienceImplFromJson(Map<String, dynamic> json) =>
    _$ExperienceImpl(
      id: (json['id'] as num).toInt(),
      userId: json['user_id'] as String,
      title: json['title'] as String,
      role: json['role'] as String?,
      experienceType: json['experience_type'] as String? ?? 'project',
      description: json['description'] as String?,
      contributions: (json['contributions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      techStack: (json['tech_stack'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      projectUrl: json['project_url'] as String?,
      imageUrl: json['image_url'] as String?,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      isCurrent: json['is_current'] as bool? ?? false,
      isVerified: json['is_verified'] as bool? ?? false,
      isFeatured: json['is_featured'] as bool? ?? false,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ExperienceImplToJson(_$ExperienceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'role': instance.role,
      'experience_type': instance.experienceType,
      'description': instance.description,
      'contributions': instance.contributions,
      'tech_stack': instance.techStack,
      'project_url': instance.projectUrl,
      'image_url': instance.imageUrl,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'is_current': instance.isCurrent,
      'is_verified': instance.isVerified,
      'is_featured': instance.isFeatured,
      'display_order': instance.displayOrder,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$ExperienceCreateImpl _$$ExperienceCreateImplFromJson(
        Map<String, dynamic> json) =>
    _$ExperienceCreateImpl(
      title: json['title'] as String,
      role: json['role'] as String?,
      experienceType: json['experience_type'] as String? ?? 'project',
      description: json['description'] as String?,
      contributions: (json['contributions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      techStack: (json['tech_stack'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      projectUrl: json['project_url'] as String?,
      imageUrl: json['image_url'] as String?,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      isCurrent: json['is_current'] as bool? ?? false,
      isFeatured: json['is_featured'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExperienceCreateImplToJson(
        _$ExperienceCreateImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'role': instance.role,
      'experience_type': instance.experienceType,
      'description': instance.description,
      'contributions': instance.contributions,
      'tech_stack': instance.techStack,
      'project_url': instance.projectUrl,
      'image_url': instance.imageUrl,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'is_current': instance.isCurrent,
      'is_featured': instance.isFeatured,
    };

_$ExperienceSummaryImpl _$$ExperienceSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$ExperienceSummaryImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      role: json['role'] as String?,
      experienceType: json['experience_type'] as String? ?? 'project',
      techStack: (json['tech_stack'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      projectUrl: json['project_url'] as String?,
      imageUrl: json['image_url'] as String?,
      isCurrent: json['is_current'] as bool? ?? false,
      isVerified: json['is_verified'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExperienceSummaryImplToJson(
        _$ExperienceSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'role': instance.role,
      'experience_type': instance.experienceType,
      'tech_stack': instance.techStack,
      'project_url': instance.projectUrl,
      'image_url': instance.imageUrl,
      'is_current': instance.isCurrent,
      'is_verified': instance.isVerified,
    };
