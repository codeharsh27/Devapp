import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../drops/presentation/activity_provider.dart';
import '../../drops/domain/activity_entry.dart';

class LiveOpsPage extends ConsumerWidget {
  const LiveOpsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(globalActivityProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                  color: Colors.redAccent, shape: BoxShape.circle),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .fadeIn(duration: 600.ms, curve: Curves.easeIn),
            const SizedBox(width: 8),
            Text("LIVE OPS",
                style: GoogleFonts.spaceMono(
                    fontWeight: FontWeight.bold, letterSpacing: 2)),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: activityAsync.when(
        data: (activities) {
          if (activities.isEmpty) {
            return Center(
              child: Text(
                "No active operations detected.",
                style: GoogleFonts.outfit(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _buildActivityTile(context, activities[index], index);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }

  Widget _buildActivityTile(
      BuildContext context, ActivityEntry activity, int index) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: activity.userAvatar != null
                ? NetworkImage(activity.userAvatar!)
                : null,
            backgroundColor: Colors.grey.withValues(alpha: 0.2),
            child: activity.userAvatar == null
                ? Text(activity.userName?[0] ?? "U",
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold, fontSize: 16))
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      activity.userName ?? "Unknown Agent",
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: const Color(0xFF00C853).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        "COMPLETED",
                        style: GoogleFonts.spaceMono(
                            fontSize: 8,
                            color: const Color(0xFF00C853),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Mission: ${activity.dropTitle}",
                  style: GoogleFonts.outfit(
                      color: theme.textTheme.bodyMedium?.color
                          ?.withValues(alpha: 0.7),
                      fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  "+${activity.xpEarned} XP • ${activity.dropDomain?.toUpperCase()}",
                  style: GoogleFonts.spaceMono(
                      color: theme.primaryColor, fontSize: 10),
                ),
              ],
            ),
          ),
          Text(
            _formatTime(activity.completedAt),
            style: GoogleFonts.spaceMono(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                fontSize: 10),
          )
        ],
      ),
    )
        .animate(delay: (index * 100).ms)
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.1, duration: 400.ms);
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }
}
