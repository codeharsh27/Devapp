import 'package:blog_app/feature/resume/data/models/resume_models.dart';
import 'package:blog_app/feature/resume/presentation/cubit/resume_builder_cubit.dart';
import 'package:blog_app/feature/resume/presentation/pages/resume_preview_page.dart';
import 'package:blog_app/feature/resume/presentation/pages/section_editor_page.dart';
import 'package:blog_app/feature/resume/presentation/widgets/section_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResumeBuilderPage extends StatefulWidget {
  const ResumeBuilderPage({super.key});

  @override
  State<ResumeBuilderPage> createState() => _ResumeBuilderPageState();
}

class _ResumeBuilderPageState extends State<ResumeBuilderPage> {
  // Controllers are now managed within the editor methods or transiently
  // We will initialize them when opening the editor for a specific section

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background for contrast
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: BlocBuilder<ResumeBuilderCubit, ResumeBuilderState>(
          builder: (context, state) {
            String name = 'Resume';
            if (state is ResumeBuilderLoaded &&
                state.resumeData.personalDetails.fullName.isNotEmpty) {
              name = state.resumeData.personalDetails.fullName;
            }
            return Column(
              children: [
                Text(
                  'Resume $name',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            );
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<ResumeBuilderCubit, ResumeBuilderState>(
        listener: (context, state) {
          if (state is ResumeBuilderError) {
            // ignore: avoid_print
            print('UI Error Listener: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5), // Longer duration to read
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is! ResumeBuilderLoaded) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          final data = state.resumeData;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              SectionTile(
                title: 'Personal Information',
                icon: Icons.person_outline,
                isCompleted: data.personalDetails.fullName.isNotEmpty,
                onTap: () => _openSectionEditor(
                  context,
                  'Personal Information',
                  _buildPersonalDetailsEditor(context, data.personalDetails),
                  () {}, // Save handled in editor
                ),
              ),
              SectionTile(
                title: 'HR Details',
                icon: Icons.work_outline,
                isCompleted: data.personalDetails.currentRole.isNotEmpty,
                onTap: () => _openSectionEditor(
                  context,
                  'HR Details',
                  _buildHRDetailsEditor(context, data.personalDetails),
                  () {},
                ),
              ),
              SectionTile(
                title: 'Professional Summary',
                icon: Icons.description_outlined,
                isCompleted: data.summary.isNotEmpty,
                onTap: () => _openSectionEditor(
                  context,
                  'Professional Summary',
                  _buildSummaryEditor(context, data.summary),
                  () {},
                ),
              ),
              SectionTile(
                title: 'Experience',
                icon: Icons.business_center_outlined,
                isCompleted: data.experience.isNotEmpty,
                onTap: () => _openSectionEditor(
                  context,
                  'Experience',
                  _buildExperienceEditor(context, data.experience),
                  () {},
                ),
              ),
              SectionTile(
                title: 'Education',
                icon: Icons.school_outlined,
                isCompleted: data.education.isNotEmpty,
                onTap: () => _openSectionEditor(
                  context,
                  'Education',
                  _buildEducationEditor(context, data.education),
                  () {},
                ),
              ),
              SectionTile(
                title: 'Skills',
                icon: Icons.lightbulb_outline,
                isCompleted: data.skills.isNotEmpty,
                onTap: () => _openSectionEditor(
                  context,
                  'Skills',
                  _buildSkillsEditor(context, data.skills),
                  () {},
                ),
              ),
              SectionTile(
                title: 'Projects',
                icon: Icons.code,
                isCompleted: data.projects.isNotEmpty,
                onTap: () => _openSectionEditor(
                  context,
                  'Projects',
                  _buildProjectsEditor(context, data.projects),
                  () {},
                ),
              ),
              SectionTile(
                title: 'Languages',
                icon: Icons.language,
                isCompleted: data.languages.isNotEmpty,
                onTap: () => _openSectionEditor(
                  context,
                  'Languages',
                  _buildLanguagesEditor(context, data.languages),
                  () {},
                ),
              ),
              SectionTile(
                title: 'Certifications',
                icon: Icons.card_membership,
                isCompleted: data.certifications.isNotEmpty,
                onTap: () => _openSectionEditor(
                  context,
                  'Certifications',
                  _buildCertificationsEditor(context, data.certifications),
                  () {},
                ),
              ),

              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () {
                  // Add custom section logic if needed
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add or remove sections'),
                style:
                    OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.black,
                    ).copyWith(
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildBottomAction(Icons.edit, 'Fill Resume', true),
            ),
            Expanded(child: _buildBottomAction(Icons.brush, 'Design', false)),
            Expanded(
              child: InkWell(
                onTap: () {
                  final state = context.read<ResumeBuilderCubit>().state;
                  if (state is ResumeBuilderLoaded) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ResumePreviewPage(resumeData: state.resumeData),
                      ),
                    );
                  }
                },
                child: _buildBottomAction(Icons.download, 'Download', false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isSelected ? Colors.black : Colors.grey),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void _openSectionEditor(
    BuildContext context,
    String title,
    Widget content,
    VoidCallback onSave,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SectionEditorPage(title: title, content: content, onSave: onSave),
      ),
    );
  }

  // --- Editor Builders ---

  Widget _buildPersonalDetailsEditor(
    BuildContext context,
    PersonalDetails details,
  ) {
    final fullNameController = TextEditingController(text: details.fullName);
    final emailController = TextEditingController(text: details.email);
    final phoneController = TextEditingController(text: details.phone);
    final locationController = TextEditingController(text: details.location);
    final linkedinController = TextEditingController(text: details.linkedinUrl);
    final portfolioController = TextEditingController(
      text: details.portfolioUrl,
    );

    return Column(
      children: [
        _buildTextField('Full Name', fullNameController),
        _buildTextField('Email', emailController),
        _buildTextField('Phone', phoneController),
        _buildTextField('Location', locationController),
        _buildTextField('LinkedIn URL', linkedinController),
        _buildTextField('Portfolio URL', portfolioController),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.read<ResumeBuilderCubit>().updatePersonalDetails(
              details.copyWith(
                fullName: fullNameController.text,
                email: emailController.text,
                phone: phoneController.text,
                location: locationController.text,
                linkedinUrl: linkedinController.text,
                portfolioUrl: portfolioController.text,
              ),
            );
            context.read<ResumeBuilderCubit>().saveResume();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Save Personal Details'),
        ),
      ],
    );
  }

  Widget _buildHRDetailsEditor(BuildContext context, PersonalDetails details) {
    final roleController = TextEditingController(text: details.currentRole);
    final expController = TextEditingController(text: details.totalExperience);
    final currentCtcController = TextEditingController(
      text: details.currentCtc,
    );
    final expectedCtcController = TextEditingController(
      text: details.expectedCtc,
    );
    final noticeController = TextEditingController(text: details.noticePeriod);
    final locationsController = TextEditingController(
      text: details.preferredLocations.join(', '),
    );
    bool openToRelocate = details.openToRelocate;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            _buildTextField('Current Role', roleController),
            _buildTextField('Total Experience', expController),
            _buildTextField('Current CTC', currentCtcController),
            _buildTextField('Expected CTC', expectedCtcController),
            _buildTextField('Notice Period', noticeController),
            _buildTextField('Preferred Locations', locationsController),
            SwitchListTile(
              title: const Text('Open to Relocate'),
              value: openToRelocate,
              activeColor: Colors.black,
              onChanged: (val) => setState(() => openToRelocate = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<ResumeBuilderCubit>().updatePersonalDetails(
                  details.copyWith(
                    currentRole: roleController.text,
                    totalExperience: expController.text,
                    currentCtc: currentCtcController.text,
                    expectedCtc: expectedCtcController.text,
                    noticePeriod: noticeController.text,
                    preferredLocations: locationsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList(),
                    openToRelocate: openToRelocate,
                  ),
                );
                context.read<ResumeBuilderCubit>().saveResume();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Save HR Details'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryEditor(BuildContext context, String summary) {
    final controller = TextEditingController(text: summary);
    return Column(
      children: [
        TextField(
          controller: controller,
          maxLines: 8,
          decoration: InputDecoration(
            labelText: 'Professional Summary',
            alignLabelWithHint: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.read<ResumeBuilderCubit>().updateSummary(controller.text);
            context.read<ResumeBuilderCubit>().saveResume();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Save Summary'),
        ),
      ],
    );
  }

  Widget _buildExperienceEditor(
    BuildContext context,
    List<Experience> experience,
  ) {
    return Column(
      children: [
        ...experience.asMap().entries.map((entry) {
          final index = entry.key;
          final exp = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                exp.jobTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${exp.company} • ${exp.startDate} - ${exp.endDate}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  context.read<ResumeBuilderCubit>().removeExperience(index);
                  context.read<ResumeBuilderCubit>().saveResume();
                  Navigator.pop(context); // Close to refresh (simple way)
                },
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => _showAddExperienceDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('Add Experience'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationEditor(
    BuildContext context,
    List<Education> education,
  ) {
    return Column(
      children: [
        ...education.asMap().entries.map((entry) {
          final index = entry.key;
          final edu = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                edu.institution,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${edu.degree} • ${edu.startDate} - ${edu.endDate}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  context.read<ResumeBuilderCubit>().removeEducation(index);
                  context.read<ResumeBuilderCubit>().saveResume();
                  Navigator.pop(context);
                },
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => _showAddEducationDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('Add Education'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsEditor(BuildContext context, List<String> skills) {
    final controller = TextEditingController();
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills
              .map(
                (skill) => Chip(
                  label: Text(skill),
                  onDeleted: () {
                    final newSkills = List<String>.from(skills)..remove(skill);
                    context.read<ResumeBuilderCubit>().updateSkills(newSkills);
                    context.read<ResumeBuilderCubit>().saveResume();
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildTextField('Add Skill', controller)),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.add_circle, size: 40, color: Colors.black),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  final newSkills = List<String>.from(skills)
                    ..add(controller.text);
                  context.read<ResumeBuilderCubit>().updateSkills(newSkills);
                  context.read<ResumeBuilderCubit>().saveResume();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProjectsEditor(BuildContext context, List<Project> projects) {
    return Column(
      children: [
        ...projects.asMap().entries.map((entry) {
          final index = entry.key;
          final proj = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                proj.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                proj.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  context.read<ResumeBuilderCubit>().removeProject(index);
                  context.read<ResumeBuilderCubit>().saveResume();
                  Navigator.pop(context);
                },
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => _showAddProjectDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('Add Project'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguagesEditor(BuildContext context, List<Language> languages) {
    return Column(
      children: [
        ...languages.asMap().entries.map((entry) {
          final index = entry.key;
          final lang = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                lang.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(lang.proficiency),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  context.read<ResumeBuilderCubit>().removeLanguage(index);
                  context.read<ResumeBuilderCubit>().saveResume();
                  Navigator.pop(context);
                },
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => _showAddLanguageDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('Add Language'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildCertificationsEditor(
    BuildContext context,
    List<Certification> certifications,
  ) {
    return Column(
      children: [
        ...certifications.asMap().entries.map((entry) {
          final index = entry.key;
          final cert = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                cert.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${cert.issuer} • ${cert.date}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  context.read<ResumeBuilderCubit>().removeCertification(index);
                  context.read<ResumeBuilderCubit>().saveResume();
                  Navigator.pop(context);
                },
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => _showAddCertificationDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('Add Certification'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }

  // --- Dialogs (Reused logic, simplified) ---

  void _showAddExperienceDialog(BuildContext context) {
    // ... (Same as before, but calling saveResume and pop)
    // For brevity, I'll implement one fully and others similarly
    final titleController = TextEditingController();
    final companyController = TextEditingController();
    final startController = TextEditingController();
    final endController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Experience'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Job Title', titleController),
              _buildTextField('Company', companyController),
              _buildTextField('Start Date', startController),
              _buildTextField('End Date', endController),
              _buildTextField('Description', descController),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ResumeBuilderCubit>().addExperience(
                Experience(
                  jobTitle: titleController.text,
                  company: companyController.text,
                  startDate: startController.text,
                  endDate: endController.text,
                  description: descController.text,
                  isCurrent: false,
                ),
              );
              context.read<ResumeBuilderCubit>().saveResume();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close editor to refresh
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddEducationDialog(BuildContext context) {
    final schoolController = TextEditingController();
    final degreeController = TextEditingController();
    final startController = TextEditingController();
    final endController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Education'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Institution', schoolController),
              _buildTextField('Degree', degreeController),
              _buildTextField('Start Date', startController),
              _buildTextField('End Date', endController),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ResumeBuilderCubit>().addEducation(
                Education(
                  institution: schoolController.text,
                  degree: degreeController.text,
                  startDate: startController.text,
                  endDate: endController.text,
                  description: '',
                ),
              );
              context.read<ResumeBuilderCubit>().saveResume();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final linkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Project'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Title', titleController),
              _buildTextField('Description', descController),
              _buildTextField('Link', linkController),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ResumeBuilderCubit>().addProject(
                Project(
                  title: titleController.text,
                  description: descController.text,
                  link: linkController.text,
                  technologies: [],
                ),
              );
              context.read<ResumeBuilderCubit>().saveResume();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddLanguageDialog(BuildContext context) {
    final nameController = TextEditingController();
    final proficiencyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField('Language', nameController),
            _buildTextField('Proficiency', proficiencyController),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ResumeBuilderCubit>().addLanguage(
                Language(
                  name: nameController.text,
                  proficiency: proficiencyController.text,
                ),
              );
              context.read<ResumeBuilderCubit>().saveResume();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddCertificationDialog(BuildContext context) {
    final nameController = TextEditingController();
    final issuerController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Certification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField('Name', nameController),
            _buildTextField('Issuer', issuerController),
            _buildTextField('Date', dateController),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ResumeBuilderCubit>().addCertification(
                Certification(
                  name: nameController.text,
                  issuer: issuerController.text,
                  date: dateController.text,
                ),
              );
              context.read<ResumeBuilderCubit>().saveResume();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
