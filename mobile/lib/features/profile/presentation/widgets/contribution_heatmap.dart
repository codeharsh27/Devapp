import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:google_fonts/google_fonts.dart';

class ContributionHeatmap extends StatelessWidget {
  final Map<DateTime, int> datasets;

  const ContributionHeatmap({super.key, required this.datasets});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, "ACTIVITY MAP"),
          const SizedBox(height: 20),
          HeatMap(
            datasets: datasets,
            colorMode: ColorMode.opacity,
            showText: false,
            scrollable: true,
            colorsets: {
              1: const Color(0xFF1E1B4B), // Dark Indigo
              3: const Color(0xFF312E81),
              5: const Color(0xFF4338CA),
              7: const Color(0xFF4F46E5),
              10: const Color(0xFF818CF8), // Light Indigo
            },
            onClick: (value) {},
            startDate: DateTime.now().subtract(const Duration(days: 60)),
            endDate: DateTime.now(),
            size: 20,
            textColor: theme.textTheme.bodySmall?.color?.withOpacity(0.3),
          )
        ],
      ).animate().fadeIn(delay: 1200.ms),
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
}
