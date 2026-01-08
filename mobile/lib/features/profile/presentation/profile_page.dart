import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../drops/data/drops_repository.dart';
import '../../drops/domain/user_model.dart';
import 'widgets/profile_header.dart';
import 'widgets/stats_control_panel.dart';
import 'widgets/skill_matrix.dart';
import 'widgets/career_timeline.dart';
import 'widgets/contribution_heatmap.dart';
import 'widgets/profile_drawer.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late Map<DateTime, int> _heatMapDatasets;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _heatMapDatasets = _generateMockHeatMap();
  }

  Map<DateTime, int> _generateMockHeatMap() {
    final Map<DateTime, int> dataset = {};
    final now = DateTime.now();
    final random = Random();
    final start = now.subtract(const Duration(days: 365));
    final end = now.add(const Duration(days: 365));

    for (int i = 0; i < end.difference(start).inDays; i++) {
      final date = start.add(Duration(days: i));
      if (random.nextDouble() > 0.4) {
        dataset[DateTime(date.year, date.month, date.day)] =
            random.nextInt(10) + 1;
      }
    }
    return dataset;
  }

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
                        .withOpacity(isDark ? 0.2 : 0.05), // Indigo
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          )
              .animate()
              .scale(duration: 3.seconds, curve: Curves.easeInOut)
              .fadeIn(),
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
                        .withOpacity(isDark ? 0.15 : 0.05), // Cyan
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          )
              .animate()
              .scale(duration: 4.seconds, curve: Curves.easeInOut)
              .fadeIn(delay: 500.ms),

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
              const SliverToBoxAdapter(
                child: SkillMatrix(),
              ),

              const SliverGap(40),

              // Experience Timeline
              const SliverToBoxAdapter(
                child: CareerTimeline(),
              ),

              const SliverGap(40),

              // Contribution Graph
              SliverToBoxAdapter(
                child: ContributionHeatmap(datasets: _heatMapDatasets),
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

class SliverGap extends StatelessWidget {
  final double size;
  const SliverGap(this.size, {super.key});
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: SizedBox(height: size));
  }
}
