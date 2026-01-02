import 'dart:io';

import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:blog_app/feature/profile/domain/entities/user_profile.dart';
import 'package:blog_app/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:blog_app/feature/profile/presentation/bloc/profile_event.dart';
import 'package:blog_app/feature/profile/presentation/bloc/profile_state.dart';
import 'package:blog_app/feature/resume/data/models/resume_models.dart';
import 'package:blog_app/feature/resume/presentation/cubit/resume_builder_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  // Color Palette Convenience
  Color get _primaryColor => AppPallete.primaryColor;
  Color get _secondaryColor => AppPallete.secondaryColor;

  // Step 1 Controllers (Profile Specific)
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _countryCodeController;
  late TextEditingController _phoneController;
  late TextEditingController _aboutController;
  late TextEditingController _linkedinController;
  late TextEditingController _githubController;
  late TextEditingController _locationController;
  File? _imageFile;

  // Step 2 Controllers (Experience)
  late TextEditingController _expJobTitleController;
  late TextEditingController _expCompanyController;
  late TextEditingController _expStartDateController;
  late TextEditingController _expEndDateController;
  late TextEditingController _expDescriptionController;

  // Step 3 Controllers (Education)
  late TextEditingController _eduInstitutionController;
  late TextEditingController _eduDegreeController;
  late TextEditingController _eduStartDateController;
  late TextEditingController _eduEndDateController;
  late TextEditingController _eduScoreController;

  // Step 4 Controllers (Skills)
  late TextEditingController _skillController;

  // Socials
  late TextEditingController _xController;

  // Step 5 Controllers (Projects & Certifications)
  late TextEditingController _projTitleController;
  late TextEditingController _projDescriptionController;
  late TextEditingController _projLinkController;
  late TextEditingController _certNameController;
  late TextEditingController _certIssuerController;
  late TextEditingController _certDateController;

  late TextEditingController _preferredRoleController;
  late TextEditingController _preferredLocationController;

  late UserProfile _userProfile;
  bool _isSaving = false;

  // Dropdown Options
  final List<String> _techJobRoles = [
    'Software Engineer',
    'Frontend Developer',
    'Backend Developer',
    'Full Stack Developer',
    'Mobile Developer',
    'Product Manager',
    'UI/UX Designer',
    'DevOps Engineer',
    'Data Scientist',
    'AI Engineer',
  ];

  final List<String> _degrees = [
    'Bachelor of Science',
    'Bachelor of Arts',
    'Master of Science',
    'Master of Business Administration',
    'PhD',
    'Associate Degree',
    'Diploma',
  ];

  final List<String> _recommendedLocations = [
    'Pune, India',
    'Mumbai, India',
    'Bangalore, India',
    'Delhi, India',
    'Hyderabad, India',
    'Chennai, India',
    'San Francisco, USA',
    'New York, USA',
    'Remote',
  ];

  final List<String> _recommendedSkills = [
    'Flutter',
    'Dart',
    'Java',
    'Python',
    'React',
    'AWS',
    'Figma',
    'UI/UX',
  ];

  final List<String> _countryCodes = [
    '+91 (IN)',
    '+1 (US)',
    '+44 (UK)',
    '+61 (AU)',
    '+81 (JP)',
    '+49 (DE)',
    '+33 (FR)',
    '+86 (CN)',
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadInitialData();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _countryCodeController = TextEditingController(text: '+91 (IN)');
    _phoneController = TextEditingController();
    _aboutController = TextEditingController();
    _linkedinController = TextEditingController();
    _githubController = TextEditingController();
    _xController = TextEditingController();
    _locationController = TextEditingController();

    _expJobTitleController = TextEditingController();
    _expCompanyController = TextEditingController();
    _expStartDateController = TextEditingController();
    _expEndDateController = TextEditingController();
    _expDescriptionController = TextEditingController();

    _eduInstitutionController = TextEditingController();
    _eduDegreeController = TextEditingController();
    _eduStartDateController = TextEditingController();
    _eduEndDateController = TextEditingController();
    _eduScoreController = TextEditingController();

    _skillController = TextEditingController();

    _projTitleController = TextEditingController();
    _projDescriptionController = TextEditingController();
    _projLinkController = TextEditingController();
    _certNameController = TextEditingController();
    _certIssuerController = TextEditingController();
    _certDateController = TextEditingController();
    _preferredRoleController = TextEditingController();
    _preferredLocationController = TextEditingController();
  }

  void _loadInitialData() {
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileLoaded) {
      _userProfile = profileState.profile;
      _firstNameController.text = _userProfile.name;
      _emailController.text = _userProfile.email;
      if (_userProfile.phone != null && _userProfile.phone!.isNotEmpty) {
        // Basic logic to check if it starts with a known code could go here
        // For now, we assume standard format or just keep it in phone if no match
        // But simplest is to just load it into phone and let user sort it out or default code.
        // Actually, let's try to preserve code if we can match it.
        var phone = _userProfile.phone!;
        bool codeFound = false;
        for (var code in _countryCodes) {
          final prefix = code.split(' ').first;
          if (phone.startsWith(prefix)) {
            _countryCodeController.text = code;
            _phoneController.text = phone.substring(prefix.length).trim();
            codeFound = true;
            break;
          }
        }
        if (!codeFound) {
          _phoneController.text = phone; // Fallback
        }
      } else {
        _phoneController.text = '';
      }
      _aboutController.text = _userProfile.bio ?? '';
      _linkedinController.text = _userProfile.linkedinUrl ?? '';
      _githubController.text = _userProfile.githubUrl ?? '';
      _xController.text = _userProfile.xUrl ?? '';
      _locationController.text = _userProfile.location ?? '';
    } else {
      _userProfile = UserProfile(
        id: '',
        name: '',
        email: '',
        primarySkills: [],
        additionalSkills: [],
        interests: [],
        preferredRoles: [],
        preferredLocations: [],
      );
    }

    // Sync with ResumeBuilder if available
    final resumeState = context.read<ResumeBuilderCubit>().state;
    if (resumeState is ResumeBuilderLoaded) {
      if (_firstNameController.text.isEmpty) {
        _firstNameController.text =
            resumeState.resumeData.personalDetails.fullName;
      }
      if (_emailController.text.isEmpty) {
        _emailController.text = resumeState.resumeData.personalDetails.email;
      }
      if (_phoneController.text.isEmpty) {
        _phoneController.text = resumeState.resumeData.personalDetails.phone;
      }
      if (_linkedinController.text.isEmpty) {
        _linkedinController.text =
            resumeState.resumeData.personalDetails.linkedinUrl;
      }
      if (_githubController.text.isEmpty) {
        _githubController.text =
            resumeState.resumeData.personalDetails.githubUrl;
      }
      if (_aboutController.text.isEmpty) {
        _aboutController.text = resumeState.resumeData.summary;
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _countryCodeController.dispose();
    _phoneController.dispose();
    _aboutController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _xController.dispose();
    _locationController.dispose();
    _expJobTitleController.dispose();
    _expCompanyController.dispose();
    _expStartDateController.dispose();
    _expEndDateController.dispose();
    _expDescriptionController.dispose();
    _eduInstitutionController.dispose();
    _eduDegreeController.dispose();
    _eduStartDateController.dispose();
    _eduEndDateController.dispose();
    _eduScoreController.dispose();
    _skillController.dispose();

    _projTitleController.dispose();
    _projDescriptionController.dispose();
    _projLinkController.dispose();
    _certNameController.dispose();
    _certIssuerController.dispose();
    _certDateController.dispose();

    _preferredRoleController.dispose();
    _preferredLocationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      if (!mounted) return;
      setState(() => _imageFile = File(pickedFile.path));
      if (_userProfile.id.isNotEmpty) {
        context.read<ProfileBloc>().add(
          ProfileImageUploadRequested(
            image: _imageFile!,
            userId: _userProfile.id,
          ),
        );
      }
    }
  }

  void _saveProfile() {
    setState(() {
      _isSaving = true;
    });
    final fullName = _firstNameController.text.trim();

    final resumeCubit = context.read<ResumeBuilderCubit>();
    List<String> currentSkills = [];

    if (resumeCubit.state is ResumeBuilderLoaded) {
      final resumeState = resumeCubit.state as ResumeBuilderLoaded;
      currentSkills = resumeState.resumeData.skills;

      // Update Resume Cubit State
      resumeCubit.updatePersonalDetails(
        resumeState.resumeData.personalDetails.copyWith(
          fullName: fullName,
          email: _emailController.text,
          phone:
              '${_countryCodeController.text.split(' ').first} ${_phoneController.text}'
                  .trim(),
          linkedinUrl: _linkedinController.text,
          githubUrl: _githubController.text,
        ),
      );
      resumeCubit.updateSummary(_aboutController.text);

      // Persist Resume Data
      resumeCubit.saveResume();
    }

    if (_userProfile.id.isNotEmpty) {
      final updatedProfile = _userProfile.copyWith(
        name: fullName,
        email: _emailController.text,
        phone:
            '${_countryCodeController.text.split(' ').first} ${_phoneController.text}'
                .trim(),
        bio: _aboutController.text,
        linkedinUrl: _linkedinController.text,
        githubUrl: _githubController.text,
        xUrl: _xController.text,
        preferredLocations: _userProfile.preferredLocations,
        preferredRoles: _userProfile.preferredRoles,
        primarySkills: currentSkills, // Sync skills for matching
        profilePhotoUrl: _userProfile.profilePhotoUrl,
        resumeUrl: _userProfile.resumeUrl,
        location: _locationController.text,
      );
      context.read<ProfileBloc>().add(ProfileUpdateRequested(updatedProfile));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (!mounted) return;
        if (state is ProfileLoaded) {
          if (_isSaving) {
            setState(() {
              _isSaving = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully!')),
            );
            Navigator.pop(context);
            return;
          }
          setState(() {
            _userProfile = state.profile;
            if (_firstNameController.text != _userProfile.name) {
              _firstNameController.text = _userProfile.name;
            }
            if (_emailController.text != _userProfile.email) {
              _emailController.text = _userProfile.email;
            }
            if (_aboutController.text != (_userProfile.bio ?? '')) {
              _aboutController.text = _userProfile.bio ?? '';
            }
            if (_linkedinController.text != (_userProfile.linkedinUrl ?? '')) {
              _linkedinController.text = _userProfile.linkedinUrl ?? '';
            }
            if (_githubController.text != (_userProfile.githubUrl ?? '')) {
              _githubController.text = _userProfile.githubUrl ?? '';
            }
            if (_xController.text != (_userProfile.xUrl ?? '')) {
              _xController.text = _userProfile.xUrl ?? '';
            }
            if (_locationController.text != (_userProfile.location ?? '')) {
              _locationController.text = _userProfile.location ?? '';
            }

            if (_userProfile.phone != null && _userProfile.phone!.isNotEmpty) {
              var phone = _userProfile.phone!;
              bool codeFound = false;
              for (var code in _countryCodes) {
                final prefix = code.split(' ').first;
                if (phone.startsWith(prefix)) {
                  _countryCodeController.text = code;
                  _phoneController.text = phone.substring(prefix.length).trim();
                  codeFound = true;
                  break;
                }
              }
              if (!codeFound) {
                _phoneController.text = phone;
              }
            } else {
              _phoneController.text = '';
            }
          });
        }

        if (state is ProfileError) {
          if (_isSaving) {
            setState(() {
              _isSaving = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error updating profile: ${state.message}'),
              ),
            );
          }
        }

        if (state is ProfileImageUploaded) {
          // Update local profile with new image URL and save it immediately
          setState(() {
            _userProfile = _userProfile.copyWith(
              profilePhotoUrl: state.imageUrl,
            );
          });
          context.read<ProfileBloc>().add(ProfileUpdateRequested(_userProfile));
        }
      },

      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildCustomHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('PERSONAL INFORMATION'),
                      _buildAvatarSection(),
                      _buildTextField(
                        label: 'Full Name',
                        hint: 'Marco',
                        controller: _firstNameController,
                      ),
                      _buildTextField(
                        label: 'Email Address',
                        hint: 'your@email.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildAutocomplete(
                              label: 'Code',
                              hint: '+91',
                              controller: _countryCodeController,
                              options: _countryCodes,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 4,
                            child: _buildTextField(
                              label: 'Phone',
                              hint: '9876543210',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                      _buildAutocomplete(
                        label: 'Location',
                        hint: 'New York, USA',
                        controller: _locationController,
                        options: _recommendedLocations,
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader('ABOUT ME'),
                      _buildTextField(
                        label: '',
                        hint: 'Passionate Product Designer...',
                        controller: _aboutController,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader('WORK EXPERIENCE'),
                      _buildWorkExperienceSection(),
                      const SizedBox(height: 24),
                      _buildSectionHeader('EDUCATION'),
                      _buildEducationSection(),
                      const SizedBox(height: 24),
                      _buildSectionHeader('SKILLS'),
                      _buildSkillsSection(),
                      const SizedBox(height: 24),
                      _buildSectionHeader('PREFERENCES'),
                      _buildMultiSelectPreference(
                        title: 'Preferred Job Role',
                        hint: 'Software Engineer',
                        controller: _preferredRoleController,
                        options: _techJobRoles,
                        selectedItems: _userProfile.preferredRoles,
                        onChanged: (newItems) {
                          setState(() {
                            _userProfile = _userProfile.copyWith(
                              preferredRoles: newItems,
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildMultiSelectPreference(
                        title: 'Preferred Location',
                        hint: 'Remote',
                        controller: _preferredLocationController,
                        options: _recommendedLocations,
                        selectedItems: _userProfile.preferredLocations,
                        onChanged: (newItems) {
                          setState(() {
                            _userProfile = _userProfile.copyWith(
                              preferredLocations: newItems,
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader('SOCIAL LINKS'),
                      _buildTextField(
                        label: 'GitHub',
                        hint: 'https://github.com/username',
                        controller: _githubController,
                      ),
                      _buildTextField(
                        label: 'LinkedIn',
                        hint: 'https://linkedin.com/in/username',
                        controller: _linkedinController,
                      ),
                      _buildTextField(
                        label: 'Twitter (X)',
                        hint: 'https://x.com/username',
                        controller: _xController,
                      ),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 32),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFCCB0), // Peach background from image
              ),
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                clipBehavior: Clip.antiAlias,
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : (_userProfile.profilePhotoUrl != null &&
                              _userProfile.profilePhotoUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: _userProfile.profilePhotoUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: _primaryColor,
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                size: 48,
                                color: Colors.grey[300],
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 48,
                              color: Colors.grey[300],
                            )),
              ),
            ),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B4EFF),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkExperienceSection() {
    return BlocBuilder<ResumeBuilderCubit, ResumeBuilderState>(
      builder: (context, state) {
        final experience = (state is ResumeBuilderLoaded)
            ? state.resumeData.experience
            : <Experience>[];

        return Column(
          children: [
            ...experience.reversed.map(
              (exp) => _buildExperienceCard(
                title: exp.jobTitle,
                company: exp.company,
                date: '${exp.startDate} - ${exp.endDate}',
                isCurrent: exp.isCurrent,
                icon: Icons.work,
                color: const Color(0xFFE0D9FF),
                iconColor: const Color(0xFF6B4EFF),
                onDelete: () => context
                    .read<ResumeBuilderCubit>()
                    .removeExperience(experience.indexOf(exp)),
              ),
            ),
            if (experience.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  "No experience added yet.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 0),
              child: OutlinedButton.icon(
                onPressed: () => _showAddExperienceSheet(context),
                icon: const Icon(Icons.add_circle_outline, size: 20),
                label: const Text('Add Work Experience'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: Colors.blue[100]!,
                    style: BorderStyle.solid,
                  ),
                  foregroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(0xFFF8F9FE),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEducationSection() {
    return BlocBuilder<ResumeBuilderCubit, ResumeBuilderState>(
      builder: (context, state) {
        final education = (state is ResumeBuilderLoaded)
            ? state.resumeData.education
            : <Education>[];

        return Column(
          children: [
            ...education.reversed.map(
              (edu) => _buildExperienceCard(
                title: edu.institution,
                company: edu.degree,
                date: '${edu.startDate} - ${edu.endDate}',
                isCurrent: false,
                icon: Icons.school,
                color: const Color(0xFFE3F2FD),
                iconColor: const Color(0xFF2196F3),
                onDelete: () => context
                    .read<ResumeBuilderCubit>()
                    .removeEducation(education.indexOf(edu)),
              ),
            ),
            if (education.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  "No education added yet.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 0),
              child: OutlinedButton.icon(
                onPressed: () => _showAddEducationSheet(context),
                icon: const Icon(Icons.add_circle_outline, size: 20),
                label: const Text('Add Education'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.blue[100]!),
                  foregroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(0xFFF8F9FE),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExperienceCard({
    required String title,
    required String company,
    required String date,
    required bool isCurrent,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback? onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (onDelete != null)
                      GestureDetector(
                        onTap: onDelete,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  company,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (isCurrent)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Current',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Text(
                      date,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return BlocBuilder<ResumeBuilderCubit, ResumeBuilderState>(
      builder: (context, state) {
        final skills = (state is ResumeBuilderLoaded)
            ? state.resumeData.skills
            : <String>[];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills
                    .map(
                      (skill) => _buildSkillChip(skill, () {
                        final newSkills = List<String>.from(skills)
                          ..remove(skill);
                        context.read<ResumeBuilderCubit>().updateSkills(
                          newSkills,
                        );
                      }),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _skillController,
                onSubmitted: (value) {
                  if (value.isNotEmpty && !skills.contains(value)) {
                    final newSkills = List<String>.from(skills)..add(value);
                    context.read<ResumeBuilderCubit>().updateSkills(newSkills);
                    _skillController.clear();
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Add a skill and press Enter...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.black),
                    onPressed: () {
                      if (_skillController.text.isNotEmpty &&
                          !skills.contains(_skillController.text)) {
                        final newSkills = List<String>.from(skills)
                          ..add(_skillController.text);
                        context.read<ResumeBuilderCubit>().updateSkills(
                          newSkills,
                        );
                        _skillController.clear();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Recommended Skills',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _recommendedSkills.map((skill) {
                  final isSelected = skills.contains(skill);
                  if (isSelected) return const SizedBox.shrink();
                  return ActionChip(
                    label: Text(skill),
                    backgroundColor: Colors.grey[100],
                    labelStyle: const TextStyle(color: Colors.black87),
                    shape: const StadiumBorder(side: BorderSide.none),
                    onPressed: () {
                      final newSkills = List<String>.from(skills)..add(skill);
                      context.read<ResumeBuilderCubit>().updateSkills(
                        newSkills,
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkillChip(String label, VoidCallback onDelete) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      backgroundColor: Colors.black,
      deleteIcon: const Icon(Icons.close, size: 16, color: Colors.white),
      onDeleted: onDelete,
      shape: const StadiumBorder(side: BorderSide(color: Colors.transparent)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 24),
            color: Colors.black87,
          ),
          const Expanded(
            child: Text(
              'Edit Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance back button
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: Colors.black87,
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Styled Inputs ---

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? prefixIcon,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        if (maxLines > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 4),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${controller.text.length}/500 characters',
                style: TextStyle(color: Colors.blueGrey[300], fontSize: 12),
              ),
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[400],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildAutocomplete({
    required String label,
    required String hint,
    required TextEditingController controller,
    required List<String> options,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        LayoutBuilder(
          builder: (context, constraints) {
            return Autocomplete<String>(
              initialValue: TextEditingValue(text: controller.text),
              optionsBuilder: (textVal) {
                if (textVal.text == '') {
                  return const Iterable<String>.empty();
                }
                return options.where(
                  (opt) =>
                      opt.toLowerCase().contains(textVal.text.toLowerCase()),
                );
              },
              onSelected: (val) => controller.text = val,
              fieldViewBuilder:
                  (context, textController, focusNode, onSubmitted) {
                    if (textController.text != controller.text) {
                      textController.text = controller.text;
                    }
                    textController.addListener(
                      () => controller.text = textController.text,
                    );
                    return TextField(
                      controller: textController,
                      focusNode: focusNode,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        prefixIcon: prefixIcon != null
                            ? Icon(prefixIcon, color: _secondaryColor, size: 20)
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                    );
                  },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    child: Container(
                      width: constraints.maxWidth,
                      constraints: const BoxConstraints(maxHeight: 250),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return ListTile(
                            title: Text(
                              option,
                              style: const TextStyle(fontSize: 14),
                            ),
                            onTap: () => onSelected(option),
                            dense: true,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _clearControllers(List<TextEditingController> controllers) {
    for (var c in controllers) {
      c.clear();
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text =
          "${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  void _showAddExperienceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Experience",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _buildAutocomplete(
                label: 'Job Title',
                hint: 'e.g. Senior Developer',
                controller: _expJobTitleController,
                options: _techJobRoles,
                prefixIcon: Icons.badge_outlined,
              ),
              _buildTextField(
                label: 'Company',
                hint: 'e.g. Acme Corp',
                controller: _expCompanyController,
                prefixIcon: Icons.business_outlined,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Start Date',
                      hint: 'MM/YYYY',
                      controller: _expStartDateController,
                      readOnly: true,
                      prefixIcon: Icons.calendar_today_outlined,
                      onTap: () =>
                          _selectDate(context, _expStartDateController),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: 'End Date',
                      hint: 'MM/YYYY',
                      controller: _expEndDateController,
                      readOnly: true,
                      prefixIcon: Icons.calendar_today_outlined,
                      onTap: () => _selectDate(context, _expEndDateController),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_expJobTitleController.text.isNotEmpty &&
                        _expCompanyController.text.isNotEmpty) {
                      context.read<ResumeBuilderCubit>().addExperience(
                        Experience(
                          jobTitle: _expJobTitleController.text,
                          company: _expCompanyController.text,
                          startDate: _expStartDateController.text,
                          endDate: _expEndDateController.text,
                          description: _expDescriptionController.text,
                          isCurrent: false, // Form simplification for now
                        ),
                      );
                      _clearControllers([
                        _expJobTitleController,
                        _expCompanyController,
                        _expStartDateController,
                        _expEndDateController,
                      ]);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4EFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Save Experience",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddEducationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Education",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                label: 'Institution',
                hint: 'e.g. Stanford University',
                controller: _eduInstitutionController,
                prefixIcon: Icons.account_balance_outlined,
              ),
              _buildAutocomplete(
                label: 'Degree',
                hint: 'e.g. B.S. Computer Science',
                controller: _eduDegreeController,
                options: _degrees,
                prefixIcon: Icons.school_outlined,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Start Date',
                      hint: 'MM/YYYY',
                      controller: _eduStartDateController,
                      readOnly: true,
                      prefixIcon: Icons.calendar_today_outlined,
                      onTap: () =>
                          _selectDate(context, _eduStartDateController),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: 'End Date',
                      hint: 'MM/YYYY',
                      controller: _eduEndDateController,
                      readOnly: true,
                      prefixIcon: Icons.calendar_today_outlined,
                      onTap: () => _selectDate(context, _eduEndDateController),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_eduInstitutionController.text.isNotEmpty &&
                        _eduDegreeController.text.isNotEmpty) {
                      context.read<ResumeBuilderCubit>().addEducation(
                        Education(
                          institution: _eduInstitutionController.text,
                          degree: _eduDegreeController.text,
                          startDate: _eduStartDateController.text,
                          endDate: _eduEndDateController.text,
                          score: '',
                          description: '',
                        ),
                      );
                      _clearControllers([
                        _eduInstitutionController,
                        _eduDegreeController,
                        _eduStartDateController,
                        _eduEndDateController,
                      ]);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4EFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Save Education",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelectPreference({
    required String title,
    required String hint,
    required TextEditingController controller,
    required List<String> options,
    required List<String> selectedItems,
    required Function(List<String>) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(title),
          if (selectedItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedItems.map((item) {
                  return _buildSkillChip(item, () {
                    final newItems = List<String>.from(selectedItems)
                      ..remove(item);
                    onChanged(newItems);
                  });
                }).toList(),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Autocomplete<String>(
                      optionsBuilder: (textVal) {
                        if (textVal.text == '') {
                          return const Iterable<String>.empty();
                        }
                        return options.where(
                          (opt) => opt.toLowerCase().contains(
                            textVal.text.toLowerCase(),
                          ),
                        );
                      },
                      onSelected: (val) {
                        if (!selectedItems.contains(val)) {
                          final newItems = List<String>.from(selectedItems)
                            ..add(val);
                          onChanged(newItems);
                        }
                      },
                      fieldViewBuilder:
                          (context, textController, focusNode, onSubmitted) {
                            return TextField(
                              controller: textController,
                              focusNode: focusNode,
                              onSubmitted: (val) {
                                if (val.isNotEmpty &&
                                    !selectedItems.contains(val)) {
                                  final newItems = List<String>.from(
                                    selectedItems,
                                  )..add(val);
                                  onChanged(newItems);
                                  textController.clear();
                                }
                              },
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: hint,
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    final text = textController.text.trim();
                                    if (text.isNotEmpty &&
                                        !selectedItems.contains(text)) {
                                      final newItems = List<String>.from(
                                        selectedItems,
                                      )..add(text);
                                      onChanged(newItems);
                                      textController.clear();
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            child: Container(
                              width: constraints.maxWidth,
                              constraints: const BoxConstraints(maxHeight: 250),
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final option = options.elementAt(index);
                                  return ListTile(
                                    title: Text(
                                      option,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    onTap: () {
                                      onSelected(option);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
