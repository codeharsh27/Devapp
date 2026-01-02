import 'dart:convert';

class ResumeData {
  final PersonalDetails personalDetails;
  final String summary;
  final List<Experience> experience;
  final List<Education> education;
  final List<String> skills;
  final List<Project> projects;
  final List<Language> languages;
  final List<Certification> certifications;
  final String resumeStyle;

  // AI Feedback Fields
  final double? atsScore;
  final List<String> missingSkills;
  final List<String> recommendations;

  ResumeData({
    required this.personalDetails,
    required this.summary,
    required this.experience,
    required this.education,
    required this.skills,
    required this.projects,
    required this.languages,
    required this.certifications,
    this.resumeStyle = 'Professional',
    this.atsScore,
    this.missingSkills = const [],
    this.recommendations = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'personalDetails': personalDetails.toMap(),
      'summary': summary,
      'experience': experience.map((x) => x.toMap()).toList(),
      'education': education.map((x) => x.toMap()).toList(),
      'skills': skills,
      'projects': projects.map((x) => x.toMap()).toList(),
      'languages': languages.map((x) => x.toMap()).toList(),
      'certifications': certifications.map((x) => x.toMap()).toList(),
      'resumeStyle': resumeStyle,
      'atsScore': atsScore,
      'missingSkills': missingSkills,
      'recommendations': recommendations,
    };
  }

  factory ResumeData.fromMap(Map<String, dynamic> map) {
    return ResumeData(
      personalDetails: PersonalDetails.fromMap(map['personalDetails']),
      summary: map['summary'] ?? '',
      experience: List<Experience>.from(
        map['experience']?.map((x) => Experience.fromMap(x)) ?? [],
      ),
      education: List<Education>.from(
        map['education']?.map((x) => Education.fromMap(x)) ?? [],
      ),
      skills: List<String>.from(map['skills'] ?? []),
      projects: List<Project>.from(
        map['projects']?.map((x) => Project.fromMap(x)) ?? [],
      ),
      languages: List<Language>.from(
        map['languages']?.map((x) => Language.fromMap(x)) ?? [],
      ),
      certifications: List<Certification>.from(
        map['certifications']?.map((x) => Certification.fromMap(x)) ?? [],
      ),
      resumeStyle: map['resumeStyle'] ?? 'Professional',
      atsScore: map['atsScore'] != null
          ? (map['atsScore'] as num).toDouble()
          : null,
      missingSkills: List<String>.from(map['missingSkills'] ?? []),
      recommendations: List<String>.from(map['recommendations'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ResumeData.fromJson(String source) =>
      ResumeData.fromMap(json.decode(source));

  factory ResumeData.empty() {
    return ResumeData(
      personalDetails: PersonalDetails(
        fullName: '',
        email: '',
        phone: '',
        linkedinUrl: '',
        githubUrl: '',
        portfolioUrl: '',
        location: '',
        currentRole: '',
        totalExperience: '',
        currentCtc: '',
        expectedCtc: '',
        noticePeriod: '',
        preferredLocations: [],
        openToRelocate: false,
      ),
      summary: '',
      experience: [],
      education: [],
      skills: [],
      projects: [],
      languages: [],
      certifications: [],
      resumeStyle: 'Professional',
      atsScore: null,
      missingSkills: [],
      recommendations: [],
    );
  }

  ResumeData copyWith({
    PersonalDetails? personalDetails,
    String? summary,
    List<Experience>? experience,
    List<Education>? education,
    List<String>? skills,
    List<Project>? projects,
    List<Language>? languages,
    List<Certification>? certifications,
    String? resumeStyle,
    double? atsScore,
    List<String>? missingSkills,
    List<String>? recommendations,
  }) {
    return ResumeData(
      personalDetails: personalDetails ?? this.personalDetails,
      summary: summary ?? this.summary,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      projects: projects ?? this.projects,
      languages: languages ?? this.languages,
      certifications: certifications ?? this.certifications,
      resumeStyle: resumeStyle ?? this.resumeStyle,
      atsScore: atsScore ?? this.atsScore,
      missingSkills: missingSkills ?? this.missingSkills,
      recommendations: recommendations ?? this.recommendations,
    );
  }
}

class PersonalDetails {
  final String fullName;
  final String email;
  final String phone;
  final String linkedinUrl;
  final String githubUrl;
  final String portfolioUrl;
  final String location;

  // HR Specific Fields
  final String currentRole;
  final String totalExperience;
  final String currentCtc;
  final String expectedCtc;
  final String noticePeriod;
  final List<String> preferredLocations;
  final bool openToRelocate;

  PersonalDetails({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.linkedinUrl,
    required this.githubUrl,
    required this.portfolioUrl,
    required this.location,
    required this.currentRole,
    required this.totalExperience,
    required this.currentCtc,
    required this.expectedCtc,
    required this.noticePeriod,
    required this.preferredLocations,
    required this.openToRelocate,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'linkedinUrl': linkedinUrl,
      'githubUrl': githubUrl,
      'portfolioUrl': portfolioUrl,
      'location': location,
      'currentRole': currentRole,
      'totalExperience': totalExperience,
      'currentCtc': currentCtc,
      'expectedCtc': expectedCtc,
      'noticePeriod': noticePeriod,
      'preferredLocations': preferredLocations,
      'openToRelocate': openToRelocate,
    };
  }

  factory PersonalDetails.fromMap(Map<String, dynamic> map) {
    return PersonalDetails(
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      linkedinUrl: map['linkedinUrl'] ?? '',
      githubUrl: map['githubUrl'] ?? '',
      portfolioUrl: map['portfolioUrl'] ?? '',
      location: map['location'] ?? '',
      currentRole: map['currentRole'] ?? '',
      totalExperience: map['totalExperience'] ?? '',
      currentCtc: map['currentCtc'] ?? '',
      expectedCtc: map['expectedCtc'] ?? '',
      noticePeriod: map['noticePeriod'] ?? '',
      preferredLocations: List<String>.from(map['preferredLocations'] ?? []),
      openToRelocate: map['openToRelocate'] ?? false,
    );
  }

  PersonalDetails copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? linkedinUrl,
    String? githubUrl,
    String? portfolioUrl,
    String? location,
    String? currentRole,
    String? totalExperience,
    String? currentCtc,
    String? expectedCtc,
    String? noticePeriod,
    List<String>? preferredLocations,
    bool? openToRelocate,
  }) {
    return PersonalDetails(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      location: location ?? this.location,
      currentRole: currentRole ?? this.currentRole,
      totalExperience: totalExperience ?? this.totalExperience,
      currentCtc: currentCtc ?? this.currentCtc,
      expectedCtc: expectedCtc ?? this.expectedCtc,
      noticePeriod: noticePeriod ?? this.noticePeriod,
      preferredLocations: preferredLocations ?? this.preferredLocations,
      openToRelocate: openToRelocate ?? this.openToRelocate,
    );
  }
}

class Experience {
  final String jobTitle;
  final String company;
  final String startDate;
  final String endDate;
  final String description;
  final bool isCurrent;

  Experience({
    required this.jobTitle,
    required this.company,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.isCurrent,
  });

  Map<String, dynamic> toMap() {
    return {
      'jobTitle': jobTitle,
      'company': company,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'isCurrent': isCurrent,
    };
  }

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      jobTitle: map['jobTitle'] ?? '',
      company: map['company'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      description: map['description'] ?? '',
      isCurrent: map['isCurrent'] ?? false,
    );
  }
}

class Education {
  final String institution;
  final String degree;
  final String startDate;
  final String endDate;
  final String description;
  final String score; // GPA or Percentage

  Education({
    required this.institution,
    required this.degree,
    required this.startDate,
    required this.endDate,
    required this.description,
    this.score = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'institution': institution,
      'degree': degree,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'score': score,
    };
  }

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      institution: map['institution'] ?? '',
      degree: map['degree'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      description: map['description'] ?? '',
      score: map['score'] ?? '',
    );
  }
}

class Project {
  final String title;
  final String description;
  final String link;
  final List<String> technologies;

  Project({
    required this.title,
    required this.description,
    required this.link,
    required this.technologies,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'link': link,
      'technologies': technologies,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      link: map['link'] ?? '',
      technologies: List<String>.from(map['technologies'] ?? []),
    );
  }
}

class Language {
  final String name;
  final String proficiency; // e.g., Native, Fluent, Intermediate

  Language({required this.name, required this.proficiency});

  Map<String, dynamic> toMap() {
    return {'name': name, 'proficiency': proficiency};
  }

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      name: map['name'] ?? '',
      proficiency: map['proficiency'] ?? '',
    );
  }
}

class Certification {
  final String name;
  final String issuer;
  final String date;

  Certification({required this.name, required this.issuer, required this.date});

  Map<String, dynamic> toMap() {
    return {'name': name, 'issuer': issuer, 'date': date};
  }

  factory Certification.fromMap(Map<String, dynamic> map) {
    return Certification(
      name: map['name'] ?? '',
      issuer: map['issuer'] ?? '',
      date: map['date'] ?? '',
    );
  }
}
