import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SkillMatrix extends StatelessWidget {
  final Map<String, dynamic> xpBreakdown;

  const SkillMatrix({super.key, required this.xpBreakdown});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, "SKILL MATRIX"),
          const SizedBox(height: 16),
          if (xpBreakdown.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  Icon(Icons.lock_person_rounded,
                      color: Theme.of(context)
                          .disabledColor
                          .withValues(alpha: 0.5),
                      size: 32),
                  const SizedBox(height: 12),
                  Text("SKILL MATRIX LOCKED",
                      style: GoogleFonts.spaceMono(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor)),
                  const SizedBox(height: 4),
                  Text("Complete missions to analyze your skillset.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withValues(alpha: 0.6))),
                ],
              ),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: xpBreakdown.entries.map((entry) {
                final domain = entry.key;
                final xp = (entry.value as num).toInt();
                // Mastery logic: 2000 XP = Full Bar (Level 2)
                final mastery = (xp / 2000.0).clamp(0.1, 1.0);

                return _buildSkillBadge(context, _capitalize(domain), mastery);
              }).toList(),
            )
        ],
      ).animate().fadeIn(delay: 800.ms),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Container(width: 4, height: 16, color: const Color(0xFF4F46E5)),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.spaceMono(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.5),
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillBadge(BuildContext context, String label, double mastery) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF18181B) : Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Container(
            width: 30,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: mastery,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.lerp(const Color(0xFF06B6D4),
                      const Color(0xFF4F46E5), mastery),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
