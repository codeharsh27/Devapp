import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SkillMatrix extends StatelessWidget {
  const SkillMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, "SKILL MATRIX"),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildSkillBadge(context, "Flutter", 0.9),
              _buildSkillBadge(context, "Dart", 0.85),
              _buildSkillBadge(context, "Python", 0.7),
              _buildSkillBadge(context, "System Design", 0.6),
              _buildSkillBadge(context, "UI/UX", 0.8),
            ],
          )
        ],
      ).animate().fadeIn(delay: 800.ms),
    );
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
            color:
                Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
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
