import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/feature/resume/data/models/resume_models.dart';
import 'package:blog_app/feature/resume/presentation/cubit/resume_builder_cubit.dart';
import 'package:blog_app/feature/resume/presentation/pages/resume_preview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/feature/resume/domain/services/pdf_service.dart';
import 'package:blog_app/init_dependency.dart';
import 'package:google_generative_ai/google_generative_ai.dart' hide Language;
import 'package:lottie/lottie.dart';

class ResumeWizardPage extends StatefulWidget {
  const ResumeWizardPage({super.key});

  @override
  State<ResumeWizardPage> createState() => _ResumeWizardPageState();
}

class _ResumeWizardPageState extends State<ResumeWizardPage> {
  Future<void> _generateSummary() async {
    if (_summaryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text to enhance.')),
      );
      return;
    }

    if (AppSecrets.geminiApiKey.contains('YOUR_GEMINI_API_KEY')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please add your Gemini API Key in lib/core/secrets/app_secrets.dart',
          ),
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    setState(() => _isGeneratingSummary = true);

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: AppSecrets.geminiApiKey,
      );

      final prompt =
          'Rewrite the following professional summary for a resume. Provide ONLY the rewritten text. Do not include options, bullet points, or any introductory/concluding remarks. The output should be a single, polished paragraph ready to be pasted into a resume:\n\n${_summaryController.text}';
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null) {
        setState(() {
          _summaryController.text = response.text!;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate summary: $e')),
        );
      }
    } finally {
      setState(() => _isGeneratingSummary = false);
    }
  }

  int _currentStep = 0;
  final PageController _pageController = PageController();

  // Step 1 Controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _roleController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _linkedinController;
  late TextEditingController _githubController;
  late TextEditingController _summaryController;

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

  // Step 4 Controllers (Skills & Languages)
  late TextEditingController _skillController;
  late TextEditingController _languageController;
  late TextEditingController _proficiencyController;

  // Step 5 Controllers (Projects & Certifications)
  late TextEditingController _projTitleController;
  late TextEditingController _projDescriptionController;
  late TextEditingController _projLinkController;

  late TextEditingController _certNameController;
  late TextEditingController _certIssuerController;
  late TextEditingController _certDateController;

  bool _isGeneratingSummary = false;

  final List<String> _techJobRoles = [
    'Application Developer',
    'Application Engineer',
    'Software Engineer',
    'Frontend Developer',
    'Backend Developer',
    'Full Stack Developer',
    'DevOps Engineer',
    'Data Scientist',
    'Mobile Developer',
    'UI/UX Designer',
    'Product Manager',
    'QA Engineer',
    'System Administrator',
    'Cloud Architect',
    'Machine Learning Engineer',
  ];

  final List<String> _locations = [
    'Pune, Maharashtra, India',
    'Mumbai, Maharashtra, India',
    'Bangalore, Karnataka, India',
    'Hyderabad, Telangana, India',
    'Delhi, India',
    'Chennai, Tamil Nadu, India',
    'Kolkata, West Bengal, India',
    'New York, USA',
    'London, UK',
    'San Francisco, USA',
    'Remote',
  ];

  String _resumeStyle = 'Professional';
  final List<String> _resumeStyles = [
    'Modern',
    'Minimalist',
    'Professional',
    'Creative-ATS',
    'Executive',
    'Technical',
  ];

  final List<String> _degrees = [
    'Bachelor of Science in Computer Science',
    'Bachelor of Engineering',
    'Bachelor of Technology',
    'Master of Science in Computer Science',
    'Master of Business Administration',
    'Bachelor of Arts',
    'Master of Arts',
    'PhD in Computer Science',
    'Associate Degree',
    'Diploma in Computer Engineering',
    'Bachelor of Commerce',
    'Bachelor of Business Administration',
  ];

  final List<String> _recommendedSkills = [
    'Next.js',
    'Express.js',
    'NestJS',
    'Angular',
    'Vue.js',
    'Redux',
    'Tailwind CSS',
    'SASS',
    'Bootstrap',
    'Go (Golang)',
    'Rust',
    'C#',
    '.NET Core',
    'PHP',
    'Laravel',
    'Ruby',
    'Ruby on Rails',
    'MongoDB',
    'PostgreSQL',
    'MySQL',
    'Redis',
    'Elasticsearch',
    'Apache Kafka',
    'RabbitMQ',
    'GraphQL Apollo',
    'gRPC',
    'Microservices',
    'Serverless',
    'Terraform',
    'Ansible',
    'Linux',
    'Bash Scripting',
    'CI/CD (Jenkins, GitHub Actions)',
    'Azure',
    'Google Cloud Platform (GCP)',
    'Cybersecurity Basics',
    'Penetration Testing',
    'Machine Learning',
    'Deep Learning',
    'Data Engineering',
    'Big Data (Hadoop, Spark)',
    'TensorFlow',
    'PyTorch',
    'LLM Integration',
    'Prompt Engineering',
    'Agile/Scrum',
    'Unit Testing',
    'Integration Testing',
    'End-to-End Testing (Cypress, Playwright)',
    'Selenium',
    'System Design',
    'API Design',
    'WebSockets',
    'Mobile App Architecture',
    'Performance Optimization',
    'Design Patterns',
    'Clean Code',
    'MVC / MVVM',
    'Figma (Basic UI/UX)',
    'Cloud Functions',
    'Edge Computing',
    'CI/CD Pipelines',
    'DevSecOps',
  ];

  final List<String> _recommendedLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Mandarin',
    'Hindi',
    'Japanese',
    'Russian',
    'Arabic',
    'Portuguese',
  ];
  @override
  void initState() {
    super.initState();
    final state = context.read<ResumeBuilderCubit>().state;
    final data = (state is ResumeBuilderLoaded)
        ? state.resumeData
        : ResumeData.empty();

    final nameParts = data.personalDetails.fullName.split(' ');
    _firstNameController = TextEditingController(
      text: nameParts.isNotEmpty ? nameParts.first : '',
    );
    _lastNameController = TextEditingController(
      text: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
    );
    _roleController = TextEditingController(
      text: data.personalDetails.currentRole,
    );
    _emailController = TextEditingController(text: data.personalDetails.email);
    _phoneController = TextEditingController(text: data.personalDetails.phone);
    _locationController = TextEditingController(
      text: data.personalDetails.location,
    );
    _linkedinController = TextEditingController(
      text: data.personalDetails.linkedinUrl,
    );
    _githubController = TextEditingController(
      text: data.personalDetails.githubUrl,
    );
    _summaryController = TextEditingController(text: data.summary);
    _resumeStyle = data.resumeStyle;

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
    _languageController = TextEditingController();
    _proficiencyController = TextEditingController();

    _projTitleController = TextEditingController();
    _projDescriptionController = TextEditingController();
    _projLinkController = TextEditingController();

    _certNameController = TextEditingController();
    _certIssuerController = TextEditingController();
    _certDateController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _summaryController.dispose();

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
    _languageController.dispose();
    _proficiencyController.dispose();

    _projTitleController.dispose();
    _projDescriptionController.dispose();
    _projLinkController.dispose();

    _certNameController.dispose();
    _certIssuerController.dispose();
    _certDateController.dispose();

    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentStep < 4) {
      _saveCurrentStep();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      _saveCurrentStep();
      _generateResume();
    }
  }

  void _prevPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _saveCurrentStep() {
    final cubit = context.read<ResumeBuilderCubit>();
    final state = cubit.state;
    if (state is! ResumeBuilderLoaded) return;

    var data = state.resumeData;

    if (_currentStep == 0) {
      data = data.copyWith(
        personalDetails: data.personalDetails.copyWith(
          fullName: '${_firstNameController.text} ${_lastNameController.text}'
              .trim(),
          currentRole: _roleController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          location: _locationController.text,
          linkedinUrl: _linkedinController.text,
          githubUrl: _githubController.text,
        ),
        summary: _summaryController.text,
      );
      cubit.updatePersonalDetails(data.personalDetails);
      cubit.updateSummary(data.summary);
      cubit.updateStyle(_resumeStyle);
    }
    // Other steps update directly via their specific widgets/dialogs
    cubit.saveResume();
  }

  void _generateResume() {
    final state = context.read<ResumeBuilderCubit>().state;
    if (state is ResumeBuilderLoaded) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<ResumeBuilderCubit>(),
            child: ResumeLoadingPage(resumeData: state.resumeData),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: _prevPage,
        ),
        title: Text(
          'Step ${_currentStep + 1} of 5',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _generateResume,
            child: const Text('Preview', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentStep + 1) / 5,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
                _buildStep4(),
                _buildStep5(),
              ],
            ),
          ),
          Container(
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
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _prevPage,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _currentStep == 4 ? 'Generate Resume' : 'Next',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Let\'s start with the basics.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _buildModernTextField(
                  'First name',
                  'Enter first name',
                  _firstNameController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildModernTextField(
                  'Last name',
                  'Enter last name',
                  _lastNameController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Resume Style',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _resumeStyle,
                isExpanded: true,
                items: _resumeStyles.map((String style) {
                  return DropdownMenuItem<String>(
                    value: style,
                    child: Text(style),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _resumeStyle = newValue;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildModernAutocompleteField(
            'Job title',
            'Enter job title',
            _roleController,
            _techJobRoles,
          ),
          const SizedBox(height: 24),
          _buildModernTextField('Email', 'Enter email', _emailController),
          const SizedBox(height: 24),
          _buildModernTextField(
            'Phone number',
            'Enter phone number',
            _phoneController,
          ),
          const SizedBox(height: 24),
          _buildModernAutocompleteField(
            'Location',
            'Enter location',
            _locationController,
            _locations,
          ),
          const SizedBox(height: 24),
          _buildModernTextField(
            'LinkedIn URL',
            'Enter LinkedIn URL',
            _linkedinController,
          ),
          const SizedBox(height: 24),
          _buildModernTextField(
            'Github URL',
            'Enter Github URL',
            _githubController,
          ),
          const SizedBox(height: 32),
          const Text(
            'Professional Summary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _summaryController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Write a short summary about yourself...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isGeneratingSummary ? null : _generateSummary,
              icon: _isGeneratingSummary
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(
                _isGeneratingSummary ? 'Generating...' : 'Let me Handle',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade100,
                foregroundColor: Colors.purple.shade900,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernAutocompleteField(
    String label,
    String hint,
    TextEditingController controller,
    List<String> options,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Autocomplete<String>(
              initialValue: TextEditingValue(text: controller.text),
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return options.where((String option) {
                  return option.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  );
                });
              },
              onSelected: (String selection) {
                controller.text = selection;
              },
              fieldViewBuilder:
                  (
                    BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    // Sync the local controller with the main controller
                    fieldTextEditingController.text = controller.text;
                    fieldTextEditingController.addListener(() {
                      controller.text = fieldTextEditingController.text;
                    });

                    return TextField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        isDense: true,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    );
                  },
              optionsViewBuilder:
                  (
                    BuildContext context,
                    AutocompleteOnSelected<String> onSelected,
                    Iterable<String> options,
                  ) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: constraints.maxWidth,
                          constraints: const BoxConstraints(maxHeight: 200),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);
                              return InkWell(
                                onTap: () {
                                  onSelected(option);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(option),
                                ),
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
      ],
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      // Format: MM/YYYY
      final formattedDate =
          "${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      controller.text = formattedDate;
    }
  }

  void _addExperience() {
    if (_expJobTitleController.text.isEmpty ||
        _expCompanyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job Title and Company are required')),
      );
      return;
    }

    final experience = Experience(
      jobTitle: _expJobTitleController.text,
      company: _expCompanyController.text,
      startDate: _expStartDateController.text,
      endDate: _expEndDateController.text,
      description: _expDescriptionController.text,
      isCurrent: false,
    );

    context.read<ResumeBuilderCubit>().addExperience(experience);

    // Clear form
    _expJobTitleController.clear();
    _expCompanyController.clear();
    _expStartDateController.clear();
    _expEndDateController.clear();
    _expDescriptionController.clear();
  }

  Widget _buildStep2() {
    return BlocBuilder<ResumeBuilderCubit, ResumeBuilderState>(
      builder: (context, state) {
        final experience = (state is ResumeBuilderLoaded)
            ? state.resumeData.experience
            : <Experience>[];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Experience',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add your relevant work experience.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // 1. List of Saved Experiences
              if (experience.isNotEmpty) ...[
                ...experience.asMap().entries.map((entry) {
                  final index = entry.key;
                  final exp = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
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
                          context.read<ResumeBuilderCubit>().removeExperience(
                            index,
                          );
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
              ],

              // 2. Add New Experience Form
              const Text(
                'Add New Experience',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildModernAutocompleteField(
                'Job Title',
                'e.g. Software Engineer',
                _expJobTitleController,
                _techJobRoles,
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                'Company',
                'e.g. Google',
                _expCompanyController,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildModernTextField(
                      'Start Date',
                      'MM/YYYY',
                      _expStartDateController,
                      readOnly: true,
                      onTap: () =>
                          _selectDate(context, _expStartDateController),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildModernTextField(
                      'End Date',
                      'MM/YYYY',
                      _expEndDateController,
                      readOnly: true,
                      onTap: () => _selectDate(context, _expEndDateController),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                'Description',
                'Describe your role...',
                _expDescriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _addExperience,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add Experience'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addEducation() {
    if (_eduInstitutionController.text.isEmpty ||
        _eduDegreeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Institution and Degree are required')),
      );
      return;
    }

    final education = Education(
      institution: _eduInstitutionController.text,
      degree: _eduDegreeController.text,
      startDate: _eduStartDateController.text,
      endDate: _eduEndDateController.text,
      description: '',
      score: _eduScoreController.text,
    );

    context.read<ResumeBuilderCubit>().addEducation(education);

    // Clear form
    _eduInstitutionController.clear();
    _eduDegreeController.clear();
    _eduStartDateController.clear();
    _eduEndDateController.clear();
    _eduScoreController.clear();
  }

  Widget _buildStep3() {
    return BlocBuilder<ResumeBuilderCubit, ResumeBuilderState>(
      builder: (context, state) {
        final education = (state is ResumeBuilderLoaded)
            ? state.resumeData.education
            : <Education>[];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Education',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add your educational background.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // 1. List of Saved Education
              if (education.isNotEmpty) ...[
                ...education.asMap().entries.map((entry) {
                  final index = entry.key;
                  final edu = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: ListTile(
                      title: Text(
                        edu.institution,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${edu.degree} • ${edu.startDate} - ${edu.endDate}',
                          ),
                          if (edu.score.isNotEmpty)
                            Text(
                              'GPA/Percentage: ${edu.score}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<ResumeBuilderCubit>().removeEducation(
                            index,
                          );
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
              ],

              // 2. Add New Education Form
              const Text(
                'Add New Education',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                'Institution',
                'e.g. University of Technology',
                _eduInstitutionController,
              ),
              const SizedBox(height: 16),
              _buildModernAutocompleteField(
                'Degree',
                'e.g. Bachelor of Science',
                _eduDegreeController,
                _degrees,
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                'GPA / Percentage',
                'e.g. 3.8 GPA or 85%',
                _eduScoreController,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildModernTextField(
                      'Start Date',
                      'MM/YYYY',
                      _eduStartDateController,
                      readOnly: true,
                      onTap: () =>
                          _selectDate(context, _eduStartDateController),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildModernTextField(
                      'End Date',
                      'MM/YYYY',
                      _eduEndDateController,
                      readOnly: true,
                      onTap: () => _selectDate(context, _eduEndDateController),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _addEducation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add Education'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStep4() {
    return BlocBuilder<ResumeBuilderCubit, ResumeBuilderState>(
      builder: (context, state) {
        final skills = (state is ResumeBuilderLoaded)
            ? state.resumeData.skills
            : <String>[];
        final languages = (state is ResumeBuilderLoaded)
            ? state.resumeData.languages
            : <Language>[];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SKILLS SECTION ---
              const Text(
                'Skills',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add your technical skills.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // 1. Selected Skills (Chips)
              if (skills.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skills
                      .map(
                        (skill) => Chip(
                          label: Text(skill),
                          backgroundColor: Colors.black,
                          labelStyle: const TextStyle(color: Colors.white),
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.white,
                          ),
                          onDeleted: () {
                            final newSkills = List<String>.from(skills)
                              ..remove(skill);
                            context.read<ResumeBuilderCubit>().updateSkills(
                              newSkills,
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                      )
                      .toList(),
                ),
              if (skills.isNotEmpty) const SizedBox(height: 16),

              // 2. Add New Skill Input
              Row(
                children: [
                  Expanded(
                    child: _buildModernAutocompleteField(
                      'Add Skill',
                      'e.g. Flutter',
                      _skillController,
                      _recommendedSkills,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.only(top: 28),
                    child: IconButton(
                      onPressed: () {
                        if (_skillController.text.isNotEmpty) {
                          if (!skills.contains(_skillController.text)) {
                            final newSkills = List<String>.from(skills)
                              ..add(_skillController.text);
                            context.read<ResumeBuilderCubit>().updateSkills(
                              newSkills,
                            );
                          }
                          _skillController.clear();
                        }
                      },
                      icon: const Icon(Icons.add_circle, size: 40),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3. Recommended Skills Suggestions
              const Text(
                'Recommended Skills:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _recommendedSkills
                    .where((s) => !skills.contains(s))
                    .take(8)
                    .map(
                      (skill) => ActionChip(
                        label: Text(skill),
                        backgroundColor: Colors.grey[200],
                        onPressed: () {
                          final newSkills = List<String>.from(skills)
                            ..add(skill);
                          context.read<ResumeBuilderCubit>().updateSkills(
                            newSkills,
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 24),

              // --- LANGUAGES SECTION ---
              const Text(
                'Languages',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Languages you speak.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // 1. List of Languages (Chips)
              if (languages.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: languages
                      .asMap()
                      .entries
                      .map(
                        (entry) => Chip(
                          label: Text(entry.value.name),
                          backgroundColor: Colors.black,
                          labelStyle: const TextStyle(color: Colors.white),
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.white,
                          ),
                          onDeleted: () {
                            context.read<ResumeBuilderCubit>().removeLanguage(
                              entry.key,
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                      )
                      .toList(),
                ),
              if (languages.isNotEmpty) const SizedBox(height: 16),

              // 2. Add New Language Input (No Proficiency)
              Row(
                children: [
                  Expanded(
                    child: _buildModernAutocompleteField(
                      'Add Language',
                      'e.g. English',
                      _languageController,
                      _recommendedLanguages,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.only(top: 28),
                    child: IconButton(
                      onPressed: () {
                        if (_languageController.text.isNotEmpty) {
                          final exists = languages.any(
                            (l) =>
                                l.name.toLowerCase() ==
                                _languageController.text.toLowerCase(),
                          );

                          if (!exists) {
                            context.read<ResumeBuilderCubit>().addLanguage(
                              Language(
                                name: _languageController.text,
                                proficiency: 'Fluent',
                              ),
                            );
                          }
                          _languageController.clear();
                        }
                      },
                      icon: const Icon(Icons.add_circle, size: 40),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3. Recommended Languages Suggestions
              const Text(
                'Recommended Languages:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _recommendedLanguages
                    .where((l) => !languages.any((lang) => lang.name == l))
                    .take(8)
                    .map(
                      (lang) => ActionChip(
                        label: Text(lang),
                        backgroundColor: Colors.grey[200],
                        onPressed: () {
                          context.read<ResumeBuilderCubit>().addLanguage(
                            Language(name: lang, proficiency: 'Fluent'),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addProject() {
    if (_projTitleController.text.isEmpty ||
        _projDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Project Title and Description are required'),
        ),
      );
      return;
    }

    final project = Project(
      title: _projTitleController.text,
      description: _projDescriptionController.text,
      link: _projLinkController.text,
      technologies: [],
    );

    context.read<ResumeBuilderCubit>().addProject(project);

    // Clear form
    _projTitleController.clear();
    _projDescriptionController.clear();
    _projLinkController.clear();
  }

  void _addCertification() {
    if (_certNameController.text.isEmpty ||
        _certIssuerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Certification Name and Issuer are required'),
        ),
      );
      return;
    }

    final certification = Certification(
      name: _certNameController.text,
      issuer: _certIssuerController.text,
      date: _certDateController.text,
    );

    context.read<ResumeBuilderCubit>().addCertification(certification);

    // Clear form
    _certNameController.clear();
    _certIssuerController.clear();
    _certDateController.clear();
  }

  Widget _buildStep5() {
    return BlocBuilder<ResumeBuilderCubit, ResumeBuilderState>(
      builder: (context, state) {
        final projects = (state is ResumeBuilderLoaded)
            ? state.resumeData.projects
            : <Project>[];
        final certs = (state is ResumeBuilderLoaded)
            ? state.resumeData.certifications
            : <Certification>[];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- PROJECTS SECTION ---
              const Text(
                'Projects',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Showcase your work.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // 1. List of Projects
              if (projects.isNotEmpty) ...[
                ...projects.asMap().entries.map((entry) {
                  final index = entry.key;
                  final proj = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: ListTile(
                      title: Text(
                        proj.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            proj.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (proj.link.isNotEmpty)
                            Text(
                              proj.link,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<ResumeBuilderCubit>().removeProject(
                            index,
                          );
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
              ],

              // 2. Add New Project Form
              const Text(
                'Add New Project',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                'Project Title',
                'e.g. E-commerce App',
                _projTitleController,
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                'Description',
                'Describe what you built and technologies used...',
                _projDescriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                'Link (Optional)',
                'e.g. github.com/myproject',
                _projLinkController,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _addProject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add Project'),
                ),
              ),

              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 24),

              // --- CERTIFICATIONS SECTION ---
              const Text(
                'Certifications',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add your certifications and awards.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // 1. List of Certifications
              if (certs.isNotEmpty) ...[
                ...certs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final cert = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: ListTile(
                      title: Text(
                        cert.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${cert.issuer} • ${cert.date}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context
                              .read<ResumeBuilderCubit>()
                              .removeCertification(index);
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
              ],

              // 2. Add New Certification Form
              const Text(
                'Add New Certification',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                'Certification Name',
                'e.g. AWS Certified Developer',
                _certNameController,
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                'Issuer',
                'e.g. Amazon Web Services',
                _certIssuerController,
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                'Date',
                'MM/YYYY',
                _certDateController,
                readOnly: true,
                onTap: () => _selectDate(context, _certDateController),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _addCertification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add Certification'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ResumeLoadingPage extends StatefulWidget {
  final ResumeData resumeData;
  const ResumeLoadingPage({super.key, required this.resumeData});

  @override
  State<ResumeLoadingPage> createState() => _ResumeLoadingPageState();
}

class _ResumeLoadingPageState extends State<ResumeLoadingPage> {
  String _statusText = 'Enhancing your resume with AI...';

  @override
  void initState() {
    super.initState();
    _generateAndNavigate();
  }

  Future<void> _generateAndNavigate() async {
    final cubit = context.read<ResumeBuilderCubit>();

    // 1. AI Enhancement
    final error = await cubit.generateAiEnhancedResume();

    if (!mounted) return;

    if (error != null) {
      // ignore: avoid_print
      print('AI Error caught in UI: $error');

      final shouldProceed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('AI Enhancement Failed'),
          content: SingleChildScrollView(
            child: Text(
              'We couldn\'t enhance your resume with AI.\n\nError: $error\n\nDo you want to proceed with your original data?',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Proceed Anyway'),
            ),
          ],
        ),
      );

      if (shouldProceed != true) {
        // Retry
        _generateAndNavigate();
        return;
      }
    }

    setState(() {
      _statusText = 'Generating PDF...';
    });

    // 2. Artificial delay for smooth transition
    await Future.delayed(const Duration(seconds: 1));

    // 3. Get updated data
    final state = cubit.state;
    final data = (state is ResumeBuilderLoaded)
        ? state.resumeData
        : widget.resumeData;

    // 4. Generate PDF
    final pdfBytes = await serviceLocator<PdfService>().generateResume(data);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResumePreviewPage(resumeData: data, initialBytes: pdfBytes),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3F5FF), Color(0xFFDEE4FF)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/resume_loader.json',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 20),
            Text(
              _statusText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
