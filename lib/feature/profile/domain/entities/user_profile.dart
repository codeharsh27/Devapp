class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? location;
  final String? bio;
  final String? profilePhotoUrl;

  // Professional
  final String? currentRole;
  final String? experienceLevel;
  final String? resumeUrl;
  final String? jobType; // full-time, remote, part-time

  // Skills & Goals
  final List<String> primarySkills;
  final List<String> additionalSkills;
  final String? learningGoals;
  final List<String> interests;

  // Preferences
  final List<String> preferredRoles;
  final List<String> preferredLocations;

  // Socials
  final String? linkedinUrl;
  final String? githubUrl;
  final String? xUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.location,
    this.bio,
    this.profilePhotoUrl,
    this.currentRole,
    this.experienceLevel,
    this.resumeUrl,
    this.jobType,
    this.primarySkills = const [],
    this.additionalSkills = const [],
    this.learningGoals,
    this.interests = const [],
    this.preferredRoles = const [],
    this.preferredLocations = const [],
    this.linkedinUrl,
    this.githubUrl,
    this.xUrl,
  });

  double get completeness {
    int totalFields = 15; // Selected key fields
    int filledFields = 0;

    if (name.isNotEmpty) filledFields++;
    if (email.isNotEmpty) filledFields++;
    if (phone != null && phone!.isNotEmpty) filledFields++;
    if (location != null && location!.isNotEmpty) filledFields++;
    if (bio != null && bio!.isNotEmpty) filledFields++;
    if (profilePhotoUrl != null && profilePhotoUrl!.isNotEmpty) filledFields++;
    if (currentRole != null && currentRole!.isNotEmpty) filledFields++;
    if (experienceLevel != null && experienceLevel!.isNotEmpty) filledFields++;
    if (jobType != null && jobType!.isNotEmpty) filledFields++;
    if (primarySkills.isNotEmpty) filledFields++;
    if (learningGoals != null && learningGoals!.isNotEmpty) filledFields++;
    if (interests.isNotEmpty) filledFields++;
    if (preferredRoles.isNotEmpty) filledFields++;
    if (preferredLocations.isNotEmpty) filledFields++;
    if (linkedinUrl != null || githubUrl != null || xUrl != null) {
      filledFields++;
    }

    return filledFields / totalFields;
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? bio,
    String? profilePhotoUrl,
    String? currentRole,
    String? experienceLevel,
    String? resumeUrl,
    String? jobType,
    List<String>? primarySkills,
    List<String>? additionalSkills,
    String? learningGoals,
    List<String>? interests,
    List<String>? preferredRoles,
    List<String>? preferredLocations,
    String? linkedinUrl,
    String? githubUrl,
    String? xUrl,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      currentRole: currentRole ?? this.currentRole,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      jobType: jobType ?? this.jobType,
      primarySkills: primarySkills ?? this.primarySkills,
      additionalSkills: additionalSkills ?? this.additionalSkills,
      learningGoals: learningGoals ?? this.learningGoals,
      interests: interests ?? this.interests,
      preferredRoles: preferredRoles ?? this.preferredRoles,
      preferredLocations: preferredLocations ?? this.preferredLocations,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      xUrl: xUrl ?? this.xUrl,
    );
  }
}
