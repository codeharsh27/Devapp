import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/experience_repository.dart';
import '../domain/experience_model.dart';

// Removed unused _launchUrl method
class ExperiencePage extends ConsumerStatefulWidget {
  const ExperiencePage({super.key});

  @override
  ConsumerState<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends ConsumerState<ExperiencePage> {
  final Set<int> _expandedIds = {};

  void _toggleExpand(int id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final experiencesAsync = ref.watch(experienceRepositoryProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background gradient
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.purple.withValues(alpha: isDark ? 0.15 : 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: theme.iconTheme.color),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  "EXPERIENCE",
                  style: GoogleFonts.spaceMono(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                centerTitle: true,
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),

              // Header Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.shade400,
                                  Colors.deepPurple.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.work_outline,
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Your Portfolio",
                                  style: GoogleFonts.outfit(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Showcase your open source & project work",
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: theme.textTheme.bodyMedium?.color
                                        ?.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.1),
              ),

              // Experience List
              experiencesAsync.when(
                data: (experiences) {
                  if (experiences.isEmpty) {
                    return SliverToBoxAdapter(
                      child: _buildEmptyState(theme),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final experience = experiences[index];
                          return _ExperienceCard(
                            experience: experience,
                            isExpanded: _expandedIds.contains(experience.id),
                            onToggle: () => _toggleExpand(experience.id),
                          )
                              .animate(
                                  delay: Duration(milliseconds: 50 * index))
                              .fadeIn()
                              .slideX(begin: 0.05);
                        },
                        childCount: experiences.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text("Error loading contributions: $e"),
                    ),
                  ),
                ),
              ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ),
        ],
      ),
      // No FAB - Contributions are automatic
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons
                  .auto_awesome_outlined, // Changed icon to represent automation
              size: 64,
              color: theme.disabledColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Contributions Yet",
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Complete tasks, gigs, and open source challenges to automatically build your portfolio!",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final Experience experience;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _ExperienceCard({
    required this.experience,
    required this.isExpanded,
    required this.onToggle,
  });

  IconData get _typeIcon {
    switch (experience.experienceType) {
      case 'opensource':
        return Icons.code_rounded;
      case 'gig':
        return Icons.work_outline;
      case 'hackathon':
        return Icons.emoji_events_outlined;
      default:
        return Icons.folder_outlined;
    }
  }

  Color get _typeColor {
    switch (experience.experienceType) {
      case 'opensource':
        return Colors.green;
      case 'gig':
        return Colors.blue;
      case 'hackathon':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  String get _typeLabel {
    switch (experience.experienceType) {
      case 'opensource':
        return 'Open Source';
      case 'gig':
        return 'Gig Project';
      case 'hackathon':
        return 'Hackathon';
      default:
        return 'Project';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.cardColor,
      child: Column(
        children: [
          // Main Content (Always Visible)
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _typeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(_typeIcon, color: _typeColor, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    experience.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (experience.isVerified)
                                  Container(
                                    margin: const EdgeInsets.only(left: 6),
                                    child: const Icon(Icons.verified,
                                        color: Colors.blue, size: 18),
                                  ),
                              ],
                            ),
                            if (experience.role != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                experience.role!,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: theme.disabledColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Type & Status Chips
                  Row(
                    children: [
                      _Chip(label: _typeLabel, color: _typeColor),
                      if (experience.isCurrent) ...[
                        const SizedBox(width: 8),
                        const _Chip(label: "Current", color: Colors.green),
                      ],
                    ],
                  ),

                  // Tech Stack Preview
                  if (experience.techStack.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: experience.techStack.take(4).map((tech) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tech,
                            style: GoogleFonts.spaceMono(
                              fontSize: 11,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Expanded Content
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(context, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: theme.dividerColor.withValues(alpha: 0.3)),
          const SizedBox(height: 12),

          // Description
          if (experience.description != null &&
              experience.description!.isNotEmpty) ...[
            Text(
              "About",
              style: GoogleFonts.spaceMono(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: theme.disabledColor,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              experience.description!,
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Contributions
          if (experience.contributions.isNotEmpty) ...[
            Text(
              "Details",
              style: GoogleFonts.spaceMono(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: theme.disabledColor,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            ...experience.contributions.map((contribution) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline,
                        size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        contribution,
                        style: GoogleFonts.inter(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
          ],

          // Action Buttons
          if (experience.projectUrl != null)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _launchUrl(experience.projectUrl!),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text("View Project"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _typeColor,
                      side:
                          BorderSide(color: _typeColor.withValues(alpha: 0.5)),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceMono(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
