import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../drops/data/drops_repository.dart';
import '../../drops/domain/user_model.dart';
import 'widgets/profile_header.dart';
import 'widgets/stats_control_panel.dart';
import 'widgets/skill_matrix.dart';

import 'widgets/contribution_heatmap.dart';
import 'widgets/profile_drawer.dart';
import 'widgets/experience_preview.dart';
import 'widgets/leaderboard_preview.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userStatsAsync = ref.watch(userStatsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      endDrawer: const ProfileDrawer(),
      body: Stack(
        children: [
          // 1. Ambient Background Mesh
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF4F46E5)
                        .withValues(alpha: isDark ? 0.2 : 0.05), // Indigo
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF06B6D4)
                        .withValues(alpha: isDark ? 0.15 : 0.05), // Cyan
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 2. Main Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header & Identity
              SliverToBoxAdapter(
                child: ProfileHeader(
                  userStatsAsync: userStatsAsync,
                  onMenuPressed: () =>
                      _scaffoldKey.currentState?.openEndDrawer(),
                ),
              ),

              const SliverGap(40),

              // Stats "Control Panel"
              SliverToBoxAdapter(
                child: StatsControlPanel(userStatsAsync: userStatsAsync),
              ),

              const SliverGap(40),

              // Skills "Matrix"
              SliverToBoxAdapter(
                child: SkillMatrix(
                  xpBreakdown: userStatsAsync.valueOrNull?.xpBreakdown ?? {},
                ),
              ),

              const SliverGap(40),

              // Leaderboard Preview
              const SliverToBoxAdapter(
                child: LeaderboardPreview(),
              ),

              const SliverGap(40),

              // Experience Preview (Top 2-3)
              const SliverToBoxAdapter(
                child: ExperiencePreview(),
              ),

              const SliverGap(16), // Reduced space

              // Contribution Graph
              SliverToBoxAdapter(
                child: ref.watch(userActivityProvider).when(
                      data: (data) => ContributionHeatmap(datasets: data),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, s) => const SizedBox(),
                    ),
              ),

              const SliverGap(80),
            ],
          ),
        ],
      ),
    );
  }
}

final userStatsProvider = FutureProvider<UserStats>((ref) async {
  return ref.watch(dropsRepositoryProvider.notifier).getUserStats();
});

final userActivityProvider = FutureProvider<Map<DateTime, int>>((ref) async {
  return ref.watch(dropsRepositoryProvider.notifier).getUserActivity();
});

class SliverGap extends StatelessWidget {
  final double size;
  const SliverGap(this.size, {super.key});
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: SizedBox(height: size));
  }
}
