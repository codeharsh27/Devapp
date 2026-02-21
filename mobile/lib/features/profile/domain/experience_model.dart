import 'package:freezed_annotation/freezed_annotation.dart';

part 'experience_model.freezed.dart';
part 'experience_model.g.dart';

@freezed
class Experience with _$Experience {
  const factory Experience({
    required int id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    String? role,
    @JsonKey(name: 'experience_type') @Default('project') String experienceType,
    String? description,
    @Default([]) List<String> contributions,
    @JsonKey(name: 'tech_stack') @Default([]) List<String> techStack,
    @JsonKey(name: 'project_url') String? projectUrl,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'is_current') @Default(false) bool isCurrent,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
    @JsonKey(name: 'display_order') @Default(0) int displayOrder,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Experience;

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);
}

@freezed
class ExperienceCreate with _$ExperienceCreate {
  const factory ExperienceCreate({
    required String title,
    String? role,
    @JsonKey(name: 'experience_type') @Default('project') String experienceType,
    String? description,
    @Default([]) List<String> contributions,
    @JsonKey(name: 'tech_stack') @Default([]) List<String> techStack,
    @JsonKey(name: 'project_url') String? projectUrl,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'is_current') @Default(false) bool isCurrent,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
  }) = _ExperienceCreate;

  factory ExperienceCreate.fromJson(Map<String, dynamic> json) =>
      _$ExperienceCreateFromJson(json);
}

@freezed
class ExperienceSummary with _$ExperienceSummary {
  const factory ExperienceSummary({
    required int id,
    required String title,
    String? role,
    @JsonKey(name: 'experience_type') @Default('project') String experienceType,
    @JsonKey(name: 'tech_stack') @Default([]) List<String> techStack,
    @JsonKey(name: 'project_url') String? projectUrl,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_current') @Default(false) bool isCurrent,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
  }) = _ExperienceSummary;

  factory ExperienceSummary.fromJson(Map<String, dynamic> json) =>
      _$ExperienceSummaryFromJson(json);
}
