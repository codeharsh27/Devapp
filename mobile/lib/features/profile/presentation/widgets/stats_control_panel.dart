import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../drops/domain/user_model.dart';

class StatsControlPanel extends StatelessWidget {
  final AsyncValue<UserStats> userStatsAsync;

  const StatsControlPanel({super.key, required this.userStatsAsync});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.06)),
        ),
        child: userStatsAsync.when(
          data: (stats) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                  context,
                  "STREAK",
                  "${stats.completedDrops > 0 ? 7 : 0} Days",
                  const Color(0xFFFF4C4C)),
              Container(width: 1, height: 40, color: theme.dividerColor),
              _buildStatItem(context, "EXP", "${stats.totalXp} XP",
                  const Color(0xFFEAB308)),
              Container(width: 1, height: 40, color: theme.dividerColor),
              _buildStatItem(context, "DROPS", "${stats.completedDrops}",
                  const Color(0xFF06B6D4)),
              Container(width: 1, height: 40, color: theme.dividerColor),
              _buildStatItem(
                  context, "EARNINGS", "0 Rs", const Color(0xFF00C853)),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox(),
        ),
      ).animate().fadeIn(delay: 600.ms).scale(),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 6,
                height: 6,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.spaceMono(
                  fontSize: 10,
                  color:
                      theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
