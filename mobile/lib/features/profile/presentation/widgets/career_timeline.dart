import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CareerTimeline extends StatelessWidget {
  const CareerTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, "CAREER PATH"),
          const SizedBox(height: 20),
          // Timeline
          _buildExpNode(context, "Senior AI Engineer", "Tesla",
              "2023 - Present", true, false),
          _buildExpNode(context, "Frontend Engineer", "Google", "2021 - 2023",
              false, false),
          _buildExpNode(context, "Mobile Developer", "Startups", "2019 - 2021",
              false, true),
        ],
      ).animate().fadeIn(delay: 1000.ms),
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

  Widget _buildExpNode(BuildContext context, String role, String company,
      String date, bool isFirst, bool isLast) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lineColor = isDark ? const Color(0xFF27272A) : Colors.black12;

    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(color: lineColor, thickness: 2),
      afterLineStyle: LineStyle(color: lineColor, thickness: 2),
      indicatorStyle: IndicatorStyle(
        width: 40,
        height: 40,
        indicator: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF18181B) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: lineColor, width: 2),
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: isFirst
                      ? const Color(0xFF4F46E5)
                      : (isDark ? Colors.white24 : Colors.black12),
                  shape: BoxShape.circle,
                  boxShadow: isFirst
                      ? [
                          BoxShadow(
                              color: const Color(0xFF4F46E5).withOpacity(0.5),
                              blurRadius: 10)
                        ]
                      : null),
            ),
          ),
        ),
      ),
      endChild: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 32),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor.withOpacity(0.04)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role,
                  style: GoogleFonts.outfit(
                      color: theme.textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(company,
                      style: GoogleFonts.outfit(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.7),
                          fontSize: 14)),
                  Text(date,
                      style: GoogleFonts.spaceMono(
                          color: theme.textTheme.bodySmall?.color
                              ?.withOpacity(0.3),
                          fontSize: 11)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
