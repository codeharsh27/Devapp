import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../auth/presentation/auth_controller.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final secondaryTextColor =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ??
            Colors.white70;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75, // "Half" side panel
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text("MENU",
                  style: GoogleFonts.spaceMono(
                      color: secondaryTextColor.withValues(alpha: 0.5),
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(context, Icons.person_outline,
                      "Edit Profile", () => context.push('/edit-profile')),
                  _buildDrawerItem(context, Icons.currency_rupee, "Earnings ",
                      () => context.push('/earnings')),
                  _buildDrawerItem(context, Icons.leaderboard, "Leaderboard",
                      () => context.push('/leaderboard')),
                  _buildDrawerItem(context, Icons.card_membership, "Membership",
                      () => context.push('/subscription')),
                  _buildDrawerItem(context, Icons.work_outline, "Contribution",
                      () => context.push('/experience')),
                  _buildDrawerItem(context, Icons.settings_outlined, "Settings",
                      () => context.push('/settings')),
                  _buildDrawerItem(context, Icons.description_outlined,
                      "Terms & Conditions", () => context.push('/terms')),
                ],
              ),
            ),
            Divider(color: theme.dividerColor),
            Padding(
              // Added significant bottom padding to clear any navigation bars
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: _buildDrawerItem(context, Icons.logout, "Log Out", () {
                ref.read(authControllerProvider.notifier).logout();
                context.go('/login');
              }, color: const Color(0xFFFF4C4C)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.textTheme.bodyLarge?.color;

    return ListTile(
      leading: Icon(icon, color: effectiveColor, size: 22),
      title: Text(title,
          style: GoogleFonts.outfit(
              fontSize: 16,
              color: effectiveColor,
              fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}
