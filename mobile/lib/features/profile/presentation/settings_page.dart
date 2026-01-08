import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  // Mock State Variables
  bool _pushNotifications = true;
  bool _emailDigest = false;
  bool _biometricAuth = true;
  bool _twoFactor = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("SETTINGS",
            style: GoogleFonts.spaceMono(
                color: theme.textTheme.titleLarge?.color,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: theme.iconTheme.color),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildSection("GENERAL", [
              _buildSwitchTile(
                "Push Notifications",
                "Receive alerts for drops & mentions",
                Icons.notifications_outlined,
                _pushNotifications,
                (val) => setState(() => _pushNotifications = val),
              ),
              _buildSwitchTile(
                "Email Digest",
                "Weekly summary of your progress",
                Icons.email_outlined,
                _emailDigest,
                (val) => setState(() => _emailDigest = val),
              ),
              _buildActionTile(
                "Appearance",
                "Dark Mode (OLED)",
                Icons.palette_outlined,
                onTap: _showThemePicker,
              ),
            ]),
            const SizedBox(height: 32),
            _buildSection("PRIVACY & SECURITY", [
              _buildActionTile(
                "Change Password",
                "Last changed 30 days ago",
                Icons.lock_reset,
                onTap: () => _showChangePasswordDialog(context),
              ),
              _buildSwitchTile(
                "Biometric Login",
                "FaceID / Fingerprint",
                Icons.fingerprint,
                _biometricAuth,
                (val) => setState(() => _biometricAuth = val),
              ),
              _buildSwitchTile(
                "2FA Authentication",
                "Extra layer of security",
                Icons.security,
                _twoFactor,
                (val) => setState(() => _twoFactor = val),
              ),
            ]),
            const SizedBox(height: 32),
            _buildSection("SUPPORT", [
              _buildActionTile(
                "Help Center",
                "FAQ and Documentation",
                Icons.help_outline,
                onTap: () {}, // Placeholder
              ),
              _buildActionTile(
                "Contact Us",
                "support@devapp.com",
                Icons.chat_bubble_outline,
                onTap: () {}, // Placeholder
              ),
              _buildActionTile(
                "About DevApp",
                "v1.0.0 (Build 42)",
                Icons.info_outline,
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 32),
            _buildSection("DANGER ZONE", [
              _buildActionTile("Delete Account", "Permanently remove data",
                  Icons.delete_forever_outlined,
                  isDestructive: true, onTap: _showDeleteAccountDialog),
            ]),
            const SizedBox(height: 48),
            Text(
              "Made with 💙 by DevApp Team",
              style: GoogleFonts.outfit(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                  fontSize: 12),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(title,
              style: GoogleFonts.spaceMono(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
          ),
          child: Column(children: children),
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon,
      bool value, Function(bool) onChanged) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.dividerColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.iconTheme.color, size: 20),
        ),
        title: Text(title,
            style: GoogleFonts.outfit(
                color: theme.textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: GoogleFonts.outfit(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                fontSize: 12)),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF4F46E5),
          activeTrackColor: const Color(0xFF4F46E5).withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon,
      {bool isDestructive = false, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDestructive
                ? const Color(0xFFFF4C4C).withOpacity(0.1)
                : theme.dividerColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon,
              color: isDestructive
                  ? const Color(0xFFFF4C4C)
                  : theme.iconTheme.color,
              size: 20),
        ),
        title: Text(title,
            style: GoogleFonts.outfit(
                color: isDestructive
                    ? const Color(0xFFFF4C4C)
                    : theme.textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: GoogleFonts.outfit(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                fontSize: 12)),
        trailing: Icon(Icons.chevron_right, color: theme.disabledColor),
      ),
    );
  }

  // --- Dialogs & Bottom Sheets ---

  void _showThemePicker() {
    final currentTheme = ref.read(themeProvider);
    showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).cardColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (context) => Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("APPEARANCE",
                      style: GoogleFonts.spaceMono(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.5),
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _buildThemeOption("System Default", ThemeMode.system,
                      currentTheme == ThemeMode.system),
                  _buildThemeOption("Dark Mode (OLED)", ThemeMode.dark,
                      currentTheme == ThemeMode.dark),
                  _buildThemeOption("Light Mode", ThemeMode.light,
                      currentTheme == ThemeMode.light),
                  const SizedBox(height: 20),
                ],
              ),
            ));
  }

  Widget _buildThemeOption(String label, ThemeMode mode, bool isSelected) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label,
          style: GoogleFonts.outfit(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 16)),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Color(0xFF4F46E5))
          : Icon(Icons.circle_outlined, color: Theme.of(context).disabledColor),
      onTap: () {
        ref.read(themeProvider.notifier).setTheme(mode);
        Navigator.pop(context);
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: theme.cardColor,
              title: Text("Change Password",
                  style: GoogleFonts.outfit(
                      color: theme.textTheme.titleLarge?.color,
                      fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDialogTextField("Current Password"),
                  const SizedBox(height: 16),
                  _buildDialogTextField("New Password"),
                  const SizedBox(height: 16),
                  _buildDialogTextField("Confirm Password"),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel",
                        style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.5)))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Password updated successfully")));
                    },
                    child: const Text("Update",
                        style: TextStyle(
                            color: Color(0xFF4F46E5),
                            fontWeight: FontWeight.bold))),
              ],
            ));
  }

  Widget _buildDialogTextField(String hint) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8)),
      child: TextField(
        obscureText: true,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final theme = Theme.of(context);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: theme.cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: Colors.redAccent.withOpacity(0.2))),
              title: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.redAccent),
                  const SizedBox(width: 12),
                  Text("Delete Account?",
                      style: GoogleFonts.outfit(
                          color: theme.textTheme.titleLarge?.color,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              content: Text(
                  "This action cannot be undone. All your data, drops, and earnings will be permanently removed.",
                  style: GoogleFonts.outfit(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.7))),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Keep Account",
                        style: TextStyle(
                            color: theme.textTheme.bodyLarge?.color))),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    onPressed: () {
                      Navigator.pop(context);
                      // Add logic to delete account
                    },
                    child: const Text("Delete Forever",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold))),
              ],
            ));
  }
}
