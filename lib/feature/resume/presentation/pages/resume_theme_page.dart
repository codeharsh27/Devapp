import 'package:blog_app/feature/resume/data/models/resume_models.dart';
import 'package:blog_app/feature/resume/presentation/cubit/resume_builder_cubit.dart';
import 'package:blog_app/feature/resume/presentation/pages/resume_wizard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResumeThemePage extends StatefulWidget {
  final String name;
  final String role;

  const ResumeThemePage({super.key, required this.name, required this.role});

  @override
  State<ResumeThemePage> createState() => _ResumeThemePageState();
}

class _ResumeThemePageState extends State<ResumeThemePage> {
  int _selectedTemplateIndex = 0;

  final List<Map<String, dynamic>> _templates = [
    {
      'name': 'Clean Modern',
      'color': Colors.blue.shade50,
      'image': 'assets/images/resume_template_clean_modern.png',
    },
    {
      'name': 'Classic Minimal',
      'color': Colors.grey.shade50,
      'image': 'assets/images/resume_template_classic_minimal.png',
    },
    {
      'name': 'Professional',
      'color': Colors.indigo.shade50,
      'image': 'assets/images/resume_template_professional.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedTemplate = _templates[_selectedTemplateIndex];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Template',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Large Preview Area
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 1 / 1.414, // A4 Aspect Ratio
                    child: Image.asset(
                      selectedTemplate['image'],
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Bottom Selection Panel
          Container(
            height: 280,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Template List
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: _templates.length,
                    itemBuilder: (context, index) {
                      final template = _templates[index];
                      final isSelected = index == _selectedTemplateIndex;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTemplateIndex = index;
                          });
                        },
                        child: Container(
                          width: 140,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey.shade200,
                              width: 2,
                            ),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        template['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade50,
                                    image: DecorationImage(
                                      image: AssetImage(template['image']),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Use Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final cubit = context.read<ResumeBuilderCubit>();
                        final currentData = (cubit.state is ResumeBuilderLoaded)
                            ? (cubit.state as ResumeBuilderLoaded).resumeData
                            : ResumeData.empty();

                        cubit.updatePersonalDetails(
                          currentData.personalDetails.copyWith(
                            fullName: widget.name,
                            currentRole: widget.role,
                          ),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResumeWizardPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Use This Template',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
}
