import 'package:blog_app/feature/profile/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  UserProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.location,
    super.bio,
    super.profilePhotoUrl,
    super.currentRole,
    super.experienceLevel,
    super.resumeUrl,
    super.jobType,
    super.primarySkills,
    super.additionalSkills,
    super.learningGoals,
    super.interests,
    super.preferredRoles,
    super.preferredLocations,
    super.linkedinUrl,
    super.githubUrl,
    super.xUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      location: json['location'] as String?,
      bio: json['bio'] as String?,
      profilePhotoUrl:
          json['image_url'] as String? ?? json['avatar_url'] as String?,
      currentRole: json['role'] as String? ?? json['current_role'] as String?,
      experienceLevel: json['experience_level'] as String?,
      resumeUrl: json['resume_url'] as String?,
      jobType: json['job_type'] as String?,
      primarySkills: List<String>.from(json['skills'] ?? []),
      additionalSkills: [],
      learningGoals: json['learning_goals'] as String?,
      interests: List<String>.from(json['interests'] ?? []),
      preferredRoles: List<String>.from(json['preferred_roles'] ?? []),
      preferredLocations: List<String>.from(json['preferred_locations'] ?? []),
      linkedinUrl: json['linkedin_url'] as String?,
      githubUrl: json['github_url'] as String?,
      xUrl: json['x_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'bio': bio,
      'skills': primarySkills,
      'avatar_url': profilePhotoUrl,
      'role': currentRole,
      'experience_level': experienceLevel,
      'resume_url': resumeUrl,
      'job_type': jobType,
      'learning_goals': learningGoals,
      'interests': interests,
      'preferred_roles': preferredRoles,
      'preferred_locations': preferredLocations,
      'linkedin_url': linkedinUrl,
      'github_url': githubUrl,
      'x_url': xUrl,
    };
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      location: entity.location,
      bio: entity.bio,
      profilePhotoUrl: entity.profilePhotoUrl,
      currentRole: entity.currentRole,
      experienceLevel: entity.experienceLevel,
      resumeUrl: entity.resumeUrl,
      jobType: entity.jobType,
      primarySkills: entity.primarySkills,
      additionalSkills: entity.additionalSkills,
      learningGoals: entity.learningGoals,
      interests: entity.interests,
      preferredRoles: entity.preferredRoles,
      preferredLocations: entity.preferredLocations,
      linkedinUrl: entity.linkedinUrl,
      githubUrl: entity.githubUrl,
      xUrl: entity.xUrl,
    );
  }
}
