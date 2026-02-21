import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/experience_repository.dart';
import '../../domain/experience_model.dart';

class AddExperienceSheet extends ConsumerStatefulWidget {
  final Experience? experience;

  const AddExperienceSheet({super.key, this.experience});

  @override
  ConsumerState<AddExperienceSheet> createState() => _AddExperienceSheetState();
}

class _AddExperienceSheetState extends ConsumerState<AddExperienceSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _roleController;
  late TextEditingController _descriptionController;
  late TextEditingController _projectUrlController;
  late TextEditingController _contributionController;
  late TextEditingController _techController;

  String _selectedType = 'project';
  bool _isCurrent = false;
  bool _isFeatured = false;
  List<String> _contributions = [];
  List<String> _techStack = [];
  bool _isLoading = false;

  bool get isEditing => widget.experience != null;

  @override
  void initState() {
    super.initState();
    final exp = widget.experience;
    _titleController = TextEditingController(text: exp?.title ?? '');
    _roleController = TextEditingController(text: exp?.role ?? '');
    _descriptionController =
        TextEditingController(text: exp?.description ?? '');
    _projectUrlController = TextEditingController(text: exp?.projectUrl ?? '');
    _contributionController = TextEditingController();
    _techController = TextEditingController();

    if (exp != null) {
      _selectedType = exp.experienceType;
      _isCurrent = exp.isCurrent;
      _isFeatured = exp.isFeatured;
      _contributions = List.from(exp.contributions);
      _techStack = List.from(exp.techStack);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _roleController.dispose();
    _descriptionController.dispose();
    _projectUrlController.dispose();
    _contributionController.dispose();
    _techController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (isEditing) {
        await ref.read(experienceRepositoryProvider.notifier).updateExperience(
          widget.experience!.id,
          {
            'title': _titleController.text,
            'role': _roleController.text.isEmpty ? null : _roleController.text,
            'experience_type': _selectedType,
            'description': _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text,
            'contributions': _contributions,
            'tech_stack': _techStack,
            'project_url': _projectUrlController.text.isEmpty
                ? null
                : _projectUrlController.text,
            'is_current': _isCurrent,
            'is_featured': _isFeatured,
          },
        );
      } else {
        await ref.read(experienceRepositoryProvider.notifier).createExperience(
              ExperienceCreate(
                title: _titleController.text,
                role:
                    _roleController.text.isEmpty ? null : _roleController.text,
                experienceType: _selectedType,
                description: _descriptionController.text.isEmpty
                    ? null
                    : _descriptionController.text,
                contributions: _contributions,
                techStack: _techStack,
                projectUrl: _projectUrlController.text.isEmpty
                    ? null
                    : _projectUrlController.text,
                isCurrent: _isCurrent,
                isFeatured: _isFeatured,
              ),
            );
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _addContribution() {
    final text = _contributionController.text.trim();
    if (text.isNotEmpty && !_contributions.contains(text)) {
      setState(() {
        _contributions.add(text);
        _contributionController.clear();
      });
    }
  }

  void _addTech() {
    final text = _techController.text.trim();
    if (text.isNotEmpty && !_techStack.contains(text)) {
      setState(() {
        _techStack.add(text);
        _techController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor.withValues(alpha: 0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.shade400,
                            Colors.deepPurple.shade600,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.work_outline,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEditing ? "Edit Experience" : "Add Experience",
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Form
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPadding + 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Experience Type
                        _buildSectionLabel("Type"),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _TypeChip(
                              label: "Open Source",
                              icon: Icons.code,
                              value: "opensource",
                              selected: _selectedType == "opensource",
                              onTap: () =>
                                  setState(() => _selectedType = "opensource"),
                            ),
                            _TypeChip(
                              label: "Gig",
                              icon: Icons.work,
                              value: "gig",
                              selected: _selectedType == "gig",
                              onTap: () =>
                                  setState(() => _selectedType = "gig"),
                            ),
                            _TypeChip(
                              label: "Project",
                              icon: Icons.folder,
                              value: "project",
                              selected: _selectedType == "project",
                              onTap: () =>
                                  setState(() => _selectedType = "project"),
                            ),
                            _TypeChip(
                              label: "Hackathon",
                              icon: Icons.emoji_events,
                              value: "hackathon",
                              selected: _selectedType == "hackathon",
                              onTap: () =>
                                  setState(() => _selectedType = "hackathon"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Title
                        _buildSectionLabel("Project Title *"),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          decoration: _inputDecoration("e.g., Flutter UI Kit"),
                          validator: (v) =>
                              v?.isEmpty == true ? "Title is required" : null,
                        ),

                        const SizedBox(height: 16),

                        // Role
                        _buildSectionLabel("Your Role"),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _roleController,
                          decoration: _inputDecoration(
                              "e.g., Contributor, Lead Developer"),
                        ),

                        const SizedBox(height: 16),

                        // Description
                        _buildSectionLabel("Description"),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: _inputDecoration(
                              "Brief description of the project"),
                          maxLines: 3,
                        ),

                        const SizedBox(height: 16),

                        // Project URL
                        _buildSectionLabel("Project URL"),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _projectUrlController,
                          decoration:
                              _inputDecoration("https://github.com/..."),
                          keyboardType: TextInputType.url,
                        ),

                        const SizedBox(height: 20),

                        // Tech Stack
                        _buildSectionLabel("Tech Stack"),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _techController,
                                decoration:
                                    _inputDecoration("Add technology..."),
                                onFieldSubmitted: (_) => _addTech(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _addTech,
                              icon: const Icon(Icons.add_circle),
                              color: Colors.purple,
                            ),
                          ],
                        ),
                        if (_techStack.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: _techStack.map((tech) {
                              return Chip(
                                label: Text(tech,
                                    style: GoogleFonts.spaceMono(fontSize: 12)),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () =>
                                    setState(() => _techStack.remove(tech)),
                              );
                            }).toList(),
                          ),
                        ],

                        const SizedBox(height: 20),

                        // Contributions
                        _buildSectionLabel("Contributions"),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _contributionController,
                                decoration: _inputDecoration(
                                    "What did you contribute?"),
                                onFieldSubmitted: (_) => _addContribution(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _addContribution,
                              icon: const Icon(Icons.add_circle),
                              color: Colors.purple,
                            ),
                          ],
                        ),
                        if (_contributions.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          ...List.generate(_contributions.length, (i) {
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.check_circle_outline,
                                  color: Colors.green, size: 20),
                              title: Text(_contributions[i],
                                  style: GoogleFonts.inter(fontSize: 13)),
                              trailing: IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () =>
                                    setState(() => _contributions.removeAt(i)),
                              ),
                            );
                          }),
                        ],

                        const SizedBox(height: 16),

                        // Switches
                        SwitchListTile(
                          title: Text("Currently working on this",
                              style: GoogleFonts.inter(fontSize: 14)),
                          value: _isCurrent,
                          onChanged: (v) => setState(() => _isCurrent = v),
                          contentPadding: EdgeInsets.zero,
                        ),
                        SwitchListTile(
                          title: Text("Featured on profile",
                              style: GoogleFonts.inter(fontSize: 14)),
                          subtitle: Text("Show in top 3 on your profile",
                              style: GoogleFonts.inter(
                                  fontSize: 12, color: theme.disabledColor)),
                          value: _isFeatured,
                          onChanged: (v) => setState(() => _isFeatured = v),
                          contentPadding: EdgeInsets.zero,
                        ),

                        const SizedBox(height: 24),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    isEditing
                                        ? "Save Changes"
                                        : "Add Experience",
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.spaceMono(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).disabledColor,
        letterSpacing: 1,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    final theme = Theme.of(context);
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: theme.disabledColor),
      filled: true,
      fillColor: theme.cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? Colors.purple.withValues(alpha: 0.2)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.purple : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: selected ? Colors.purple : Colors.grey),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? Colors.purple : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
