import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../../drops/data/drops_repository.dart';
import '../../drops/domain/user_model.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _githubController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _portfolioController = TextEditingController();
  final _upiIdController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isUploadingImage = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await ref.read(dropsRepositoryProvider.notifier).getMe();
      if (mounted) {
        setState(() {
          _user = user;
          _nameController.text = user.fullName ?? '';
          _bioController.text = user.bio ?? '';
          _upiIdController.text = user.upiId ?? '';

          if (user.socialLinks != null) {
            _githubController.text = user.socialLinks!['github'] ?? '';
            _linkedinController.text = user.socialLinks!['linkedin'] ?? '';
            _portfolioController.text = user.socialLinks!['portfolio'] ?? '';
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load profile: $e")),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    if (_user == null) return;

    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery, maxWidth: 800, maxHeight: 800);

    if (image == null) return;

    setState(() => _isUploadingImage = true);

    try {
      final file = File(image.path);
      final fileExt = image.path.split('.').last;
      final fileName =
          '${_user!.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = fileName;

      // Upload to Supabase 'avatars' bucket
      final storage = Supabase.instance.client.storage.from('avatars');
      await storage.upload(filePath, file);

      // Get Public URL
      final imageUrl = storage.getPublicUrl(filePath);

      // Verify URL Update immediately
      await ref
          .read(dropsRepositoryProvider.notifier)
          .updateProfile(avatarUrl: imageUrl);

      // Update Local State to reflect change instantly
      if (mounted) {
        setState(() {
          _user = _user!.copyWith(avatarUrl: imageUrl);
          _isUploadingImage = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile picture updated!")),
        );
      }
    } catch (e) {
      debugPrint(
          "Profile Upload Error: $e. ACTION REQUIRED: Create 'avatars' bucket in Supabase Dashboard.");
      if (mounted) {
        setState(() => _isUploadingImage = false);

        String errorMessage = "Image Upload Failed";
        if (e.toString().contains("Bucket not found")) {
          errorMessage =
              "SETUP REQUIRED: Create 'avatars' bucket in Supabase Dashboard (Public).";
        } else if (e.toString().contains("statusCode: 403")) {
          errorMessage =
              "PERMISSION DENIED: Check RLS policies for 'avatars' bucket.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
                label: "Copy",
                textColor: Colors.white,
                onPressed: () =>
                    Clipboard.setData(ClipboardData(text: errorMessage))),
          ),
        );
      }
    }
  }

  Future<void> _save() async {
// ... existing save logic ...
    setState(() => _isSaving = true);
    try {
      final socialLinks = {
        'github': _githubController.text.trim(),
        'linkedin': _linkedinController.text.trim(),
        'portfolio': _portfolioController.text.trim(),
      };

      // Remove empty keys
      socialLinks.removeWhere((key, value) => value.isEmpty);

      await ref.read(dropsRepositoryProvider.notifier).updateProfile(
            fullName: _nameController.text.trim(),
            bio: _bioController.text.trim(),
            upiId: _upiIdController.text.trim(),
            socialLinks: socialLinks.isEmpty
                ? null
                : Map<String, String>.from(socialLinks),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated Successfully!")),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save: $e")),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("EDIT IDENTITY",
            style: GoogleFonts.spaceMono(
                color: theme.textTheme.titleLarge?.color,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        centerTitle: true,
        leading: BackButton(color: theme.iconTheme.color),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          _isSaving
              ? const Center(
                  child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))))
              : TextButton(
                  onPressed: _save,
                  child: Text("SAVE",
                      style: GoogleFonts.outfit(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold)),
                )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickAndUploadImage,
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: theme.dividerColor.withValues(alpha: 0.1),
                              width: 2),
                          image: DecorationImage(
                              image: NetworkImage(_user?.avatarUrl ??
                                  "https://via.placeholder.com/150"),
                              fit: BoxFit.cover)),
                      child: _isUploadingImage
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white))
                          : Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black38, // Lighter overlay
                              ),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 32),
                            ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit,
                              size: 16, color: Colors.white),
                        ))
                  ],
                ),
              ),
            ).animate().scale(),
            const SizedBox(height: 48),

            // Read Only Fields (for context)
            _buildLabel("DISPLAY NAME"),
            _buildTextField(_nameController, Icons.person_outline),
            const SizedBox(height: 24),
            _buildLabel("EMAIL"),
            _buildReadOnlyField(
                _user?.email ?? "No Email", Icons.email_outlined),

            const SizedBox(height: 24),
            _buildLabel("BIO"),
            _buildTextField(_bioController, Icons.format_quote, maxLines: 3),

            const SizedBox(height: 32),
            Divider(color: theme.dividerColor.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text("PAYMENT DETAILS",
                style: GoogleFonts.spaceMono(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
            const SizedBox(height: 16),
            _buildLabel("UPI ID (For Payouts)"),
            _buildTextField(_upiIdController, Icons.payment_outlined),

            const SizedBox(height: 32),
            Divider(color: theme.dividerColor.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text("SOCIAL LINKS",
                style: GoogleFonts.spaceMono(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
            const SizedBox(height: 16),

            _buildLabel("GITHUB URL"),
            _buildTextField(_githubController, Icons.code),
            const SizedBox(height: 16),

            _buildLabel("LINKEDIN URL"),
            _buildTextField(
                _linkedinController, Icons.business_center_outlined),
            const SizedBox(height: 16),

            _buildLabel("PORTFOLIO URL"),
            _buildTextField(_portfolioController, Icons.language),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(label,
            style: GoogleFonts.spaceMono(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withValues(alpha: 0.5),
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 1)),
      ),
    );
  }

  Widget _buildReadOnlyField(String value, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(icon,
              color: theme.iconTheme.color?.withValues(alpha: 0.3), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(value,
                style: GoogleFonts.outfit(
                    color: theme.textTheme.bodyMedium?.color
                        ?.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500)),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon,
      {int maxLines = 1}) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.outfit(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon:
              Icon(icon, color: theme.iconTheme.color?.withValues(alpha: 0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}
