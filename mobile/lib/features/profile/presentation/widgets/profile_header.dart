import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../drops/domain/user_model.dart';
import '../../../auth/presentation/auth_provider.dart';

class ProfileHeader extends ConsumerWidget {
  final AsyncValue<UserStats> userStatsAsync;
  final VoidCallback onMenuPressed;

  const ProfileHeader({
    super.key,
    required this.userStatsAsync,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryTextColor = theme.textTheme.bodyLarge?.color ?? Colors.white;

    final user = ref.watch(authProvider).value;
    final userEmail = user?.email ?? 'designer@devapp.com';
    final userInitial = userEmail.isNotEmpty ? userEmail[0].toUpperCase() : 'D';
    final username = user?.fullName ?? userEmail.split('@')[0];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: theme.iconTheme.color,
                ),
                onPressed: () {
                  ref.read(themeProvider.notifier).setTheme(
                        isDark ? ThemeMode.light : ThemeMode.dark,
                      );
                },
              ),
              IconButton(
                icon: Icon(Icons.drag_handle_rounded,
                    color: theme.iconTheme.color, size: 28),
                onPressed: onMenuPressed,
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Identity Block (Asymmetric)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar Container
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF818CF8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ]),
                child: Center(
                  child: Text(
                    userInitial,
                    style: GoogleFonts.outfit(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ).animate().fadeIn().slideX(begin: -0.2),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      username,
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: primaryTextColor,
                        height: 1.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                    const SizedBox(height: 6),
                    userStatsAsync.when(
                      data: (stats) {
                        final currentLevelXp = stats.totalXp % 1000;
                        const nextLevelXp = 1000;
                        final progress = currentLevelXp / nextLevelXp;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.black.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: theme.dividerColor),
                              ),
                              child: Text(
                                "LEVEL ${stats.level} // ${stats.rank.toUpperCase()}",
                                style: GoogleFonts.spaceMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF06B6D4),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // XP Progress Bar
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: theme.dividerColor
                                          .withValues(alpha: 0.1),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Color(0xFF06B6D4)),
                                      minHeight: 6,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "$currentLevelXp / $nextLevelXp XP",
                                  style: GoogleFonts.spaceMono(
                                      fontSize: 10,
                                      color: theme.textTheme.bodySmall?.color
                                          ?.withValues(alpha: 0.6)),
                                )
                              ],
                            ),
                          ],
                        ).animate().fadeIn(delay: 400.ms);
                      },
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
