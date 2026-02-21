import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../leaderboard/presentation/leaderboard_page.dart'; // Access provider
import '../../../drops/domain/leaderboard_entry.dart';

class LeaderboardPreview extends ConsumerWidget {
  const LeaderboardPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider("Global"));

    return InkWell(
      onTap: () => context.push('/leaderboard'),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, "TOP RANKERS"),
            const SizedBox(height: 16),
            leaderboardAsync.when(
              data: (entries) {
                if (entries.isEmpty) return const SizedBox();
                final top3 = entries.take(3).toList();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: top3.asMap().entries.map((e) {
                    final rank = e.key + 1;
                    return _buildRankCard(context, e.value, rank);
                  }).toList(),
                ).animate().fadeIn().slideX();
              },
              loading: () =>
                  const Center(child: LinearProgressIndicator(minHeight: 2)),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFF00C853).withValues(alpha: 0.1),
                          blurRadius: 6)
                    ])),
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
        ),
        Icon(Icons.chevron_right,
            size: 16, color: Theme.of(context).disabledColor),
      ],
    );
  }

  Widget _buildRankCard(
      BuildContext context, LeaderboardEntry entry, int rank) {
    final theme = Theme.of(context);
    final isFirst = rank == 1;
    final isSecond = rank == 2;
    final isTop3 = rank <= 3;

    // Config based on rank
    final double scale = isFirst ? 1.1 : (isSecond ? 1.0 : 0.95);
    final Color rankColor = isFirst
        ? const Color(0xFFFFD700) // Gold
        : isSecond
            ? const Color(0xFFC0C0C0) // Silver
            : const Color(0xFFCD7F32); // Bronze

    final double avatarSize = isFirst ? 22 : 18;

    return Expanded(
      flex: isFirst ? 4 : 3,
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(
              right: 8,
              top: isFirst ? 12 : 0, // Push Rank 1 down slightly to clear top
              bottom: isFirst ? 0 : 4 // Balance bottom
              ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: rankColor.withValues(alpha: isFirst ? 0.5 : 0.2),
                width: isFirst ? 1.5 : 1),
            boxShadow: isFirst
                ? [
                    BoxShadow(
                        color: rankColor.withValues(alpha: 0.15),
                        blurRadius: 12,
                        spreadRadius: -2)
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar with Crown
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: rankColor.withValues(alpha: 0.5),
                            width: 1.5)),
                    child: CircleAvatar(
                      radius: avatarSize,
                      backgroundImage: entry.avatarUrl != null
                          ? NetworkImage(entry.avatarUrl!)
                          : const AssetImage('assets/profile_pic.jpg')
                              as ImageProvider,
                    ),
                  ),
                  if (isFirst)
                    Positioned(
                      top: -12,
                      right: 0,
                      left: 0,
                      child: Center(
                        child: Icon(Icons.emoji_events_rounded,
                                color: rankColor, size: 18)
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .moveY(begin: 0, end: -3, duration: 1.seconds),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Rank Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  "#$rank",
                  style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      color: rankColor,
                      fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                entry.fullName?.split(' ').first ?? "User",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: isFirst ? 13 : 12,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color
                      ?.withValues(alpha: isTop3 ? 1 : 0.7),
                ),
              ),

              Text(
                "${entry.totalXp} XP",
                style: GoogleFonts.spaceMono(
                  fontSize: 9,
                  color:
                      theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
