import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../data/experience_repository.dart';
import '../../domain/experience_model.dart';

/// Widget that displays top 2-3 featured experiences on the profile page
class ExperiencePreview extends ConsumerWidget {
  const ExperiencePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredAsync = ref.watch(featuredExperiencesProvider);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                      width: 4, height: 16, color: const Color(0xFF4F46E5)),
                  const SizedBox(width: 12),
                  Text(
                    "CONTRIBUTION",
                    style: GoogleFonts.spaceMono(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodySmall?.color
                          ?.withValues(alpha: 0.5),
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => context.push('/experience'),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    "VIEW ALL",
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4F46E5),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Timeline List
          featuredAsync.when(
            data: (experiences) {
              if (experiences.isEmpty) {
                return _buildEmptyState(context, theme);
              }

              return Column(
                children: experiences.asMap().entries.map((entry) {
                  final index = entry.key;
                  final exp = entry.value;
                  final isFirst = index == 0;
                  final isLast = index == experiences.length - 1;

                  return _ContributionTimelineNode(
                    experience: exp,
                    isFirst: isFirst,
                    isLast: isLast,
                  )
                      .animate(delay: Duration(milliseconds: 100 * index))
                      .fadeIn()
                      .slideX(begin: 0.05);
                }).toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (e, s) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome_outlined,
              color: theme.disabledColor.withValues(alpha: 0.5), size: 32),
          const SizedBox(height: 12),
          Text("NO CONTRIBUTIONS",
              style: GoogleFonts.spaceMono(
                  fontWeight: FontWeight.bold, color: theme.disabledColor)),
          const SizedBox(height: 4),
          Text("Complete tasks to build your portfolio.",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                  color: theme.textTheme.bodyMedium?.color
                      ?.withValues(alpha: 0.6))),
        ],
      ),
    );
  }
}

class _ContributionTimelineNode extends StatelessWidget {
  final ExperienceSummary experience;
  final bool isFirst;
  final bool isLast;

  const _ContributionTimelineNode({
    required this.experience,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
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
                              color: const Color(0xFF4F46E5)
                                  .withValues(alpha: 0.5),
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
            border:
                Border.all(color: theme.dividerColor.withValues(alpha: 0.04)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                experience.title,
                style: GoogleFonts.outfit(
                    color: theme.textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        _capitalize(experience.experienceType),
                        style: GoogleFonts.outfit(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withValues(alpha: 0.7),
                            fontSize: 14),
                      ),
                      if (experience.isVerified) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.verified,
                            color: Colors.blue, size: 14),
                      ],
                    ],
                  ),
                  Text(
                    experience.role ?? '',
                    style: GoogleFonts.spaceMono(
                        color: theme.textTheme.bodySmall?.color
                            ?.withValues(alpha: 0.3),
                        fontSize: 11),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
