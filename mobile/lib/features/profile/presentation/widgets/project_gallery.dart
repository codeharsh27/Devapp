import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/user_submissions_provider.dart';
import '../../../drops/domain/submission.dart';

class ProjectGallery extends ConsumerWidget {
  const ProjectGallery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submissionsAsync = ref.watch(userSubmissionsProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "RECENT DROPS",
            style: GoogleFonts.spaceMono(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: submissionsAsync.when(
            data: (submissions) {
              if (submissions.isEmpty) {
                return Center(
                  child: Text(
                    "No missions completed yet.",
                    style: GoogleFonts.outfit(
                      color: theme.textTheme.bodyMedium?.color
                          ?.withValues(alpha: 0.5),
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: submissions.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final submission = submissions[index];
                  return _GalleryItem(submission: submission)
                      .animate()
                      .fadeIn(delay: (100 * index).ms)
                      .slideX(begin: 0.2, curve: Curves.easeOut);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text("Error: $err")),
          ),
        ),
      ],
    );
  }
}

class _GalleryItem extends StatelessWidget {
  final Submission submission;

  const _GalleryItem({required this.submission});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Image or Gradient
          if (submission.imageUrl != null)
            Positioned.fill(
              child: Image.network(
                submission.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            )
          else
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.primaryColor.withValues(alpha: 0.2),
                      theme.scaffoldBackgroundColor,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.code_rounded,
                    size: 48,
                    color: theme.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),

          // Overlay Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Use drop title if available, else just "Mission"
                Text(
                  submission.drop?.title ?? "Unknown Mission",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: submission.status == 'completed'
                            ? Colors.green.withValues(alpha: 0.2)
                            : Colors.red.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: submission.status == 'completed'
                              ? Colors.green
                              : Colors.red,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        submission.status.toUpperCase(),
                        style: GoogleFonts.spaceMono(
                          color: submission.status == 'completed'
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (submission.score != null)
                      Text(
                        "${submission.score}/100",
                        style: GoogleFonts.spaceMono(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
