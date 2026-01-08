import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("CAREER TIMELINE",
            style: GoogleFonts.spaceMono(
                color: theme.textTheme.titleLarge?.color,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        centerTitle: true,
        leading: BackButton(color: theme.iconTheme.color),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildTimelineItem(
              context,
              "Senior AI Engineer",
              "Tesla · Palo Alto",
              "2023 - Present",
              "Leading the Autopilot computer vision team. Optimized inference models by 40%.",
              true,
              false,
              true),
          _buildTimelineItem(
              context,
              "Frontend Engineer",
              "Google · Mountain View",
              "2021 - 2023",
              "Contributed to the Flutter material design implementation. Built internal tools for 10k+ users.",
              false,
              false,
              false),
          _buildTimelineItem(
              context,
              "Mobile Developer",
              "Startup Inc",
              "2019 - 2021",
              "Shipped 3 apps from scratch. Managed deployment to Play Store and App Store.",
              false,
              true,
              false),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
      BuildContext context,
      String role,
      String company,
      String date,
      String description,
      bool isFirst,
      bool isLast,
      bool isActive) {
    final theme = Theme.of(context);

    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
          color: isActive ? theme.primaryColor : theme.dividerColor,
          thickness: 2),
      afterLineStyle: LineStyle(color: theme.dividerColor, thickness: 2),
      indicatorStyle: IndicatorStyle(
        width: 44,
        height: 44,
        indicator: Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            shape: BoxShape.circle,
            border: Border.all(
                color: isActive ? theme.primaryColor : theme.dividerColor,
                width: 2),
          ),
          child: Center(
            child: Icon(Icons.work_outline,
                color: isActive ? theme.primaryColor : theme.disabledColor,
                size: 20),
          ),
        ),
      ),
      endChild: Container(
        // Content Tile
        margin: const EdgeInsets.only(left: 20, bottom: 40),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: isActive
                    ? theme.primaryColor.withOpacity(0.3)
                    : theme.dividerColor.withOpacity(0.1)),
            boxShadow: isActive
                ? [
                    BoxShadow(
                        color: theme.primaryColor.withOpacity(0.1),
                        blurRadius: 20)
                  ]
                : null),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(role,
                    style: GoogleFonts.outfit(
                        color: theme.textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                if (isActive)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text("CURRENT",
                        style: GoogleFonts.spaceMono(
                            fontSize: 10,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold)),
                  )
              ],
            ),
            const SizedBox(height: 4),
            Text(company,
                style: GoogleFonts.outfit(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    fontSize: 14)),
            const SizedBox(height: 12),
            Text(description,
                style: GoogleFonts.outfit(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                    height: 1.5)),
            const SizedBox(height: 12),
            Text(date,
                style: GoogleFonts.spaceMono(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.3),
                    fontSize: 12)),
          ],
        ),
      ).animate().fadeIn().slideX(begin: 0.1),
    );
  }
}
