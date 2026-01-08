import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          TextButton(
            onPressed: () {},
            child: Text("SAVE",
                style: GoogleFonts.outfit(
                    color: theme.primaryColor, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: theme.dividerColor.withOpacity(0.1),
                            width: 2),
                        image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/150"), // Placeholder
                            fit: BoxFit.cover)),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors
                            .black54, // Overlay to hint edit (keep dark for contrast with white icon)
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
                      child:
                          const Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  )
                ],
              ),
            ).animate().scale(),
            const SizedBox(height: 48),
            _buildLabel("DISPLAY NAME"),
            _buildTextField("Harsh Mule", Icons.person_outline),
            const SizedBox(height: 24),
            _buildLabel("TITLE / ROLE"),
            _buildTextField("Flutter Developer", Icons.work_outline),
            const SizedBox(height: 24),
            _buildLabel("BIO"),
            _buildTextField("Building the future.", Icons.align_horizontal_left,
                maxLines: 3),
            const SizedBox(height: 24),
            _buildLabel("LINKS"),
            _buildTextField("github.com/harsh", Icons.link),
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
                    ?.withOpacity(0.5),
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 1)),
      ),
    );
  }

  Widget _buildTextField(String initialValue, IconData icon,
      {int maxLines = 1}) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: TextFormField(
        initialValue: initialValue,
        maxLines: maxLines,
        style: GoogleFonts.outfit(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon:
              Icon(icon, color: theme.iconTheme.color?.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}
