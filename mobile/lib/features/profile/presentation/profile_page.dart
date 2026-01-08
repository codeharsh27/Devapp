import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../drops/data/drops_repository.dart';
import '../../drops/domain/user_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late Map<DateTime, int> _heatMapDatasets;
  DateTime _focusedMonth = DateTime.now();
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
    final user = Supabase.instance.client.auth.currentUser;
    final userEmail = user?.email ?? 'designer@devapp.com';
    final userInitial = userEmail.isNotEmpty ? userEmail[0].toUpperCase() : 'D';
    final username = userEmail.split('@')[0];

    final userStatsAsync = ref.watch(userStatsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Dynamic styles based on theme
    final cardColor = theme.cardColor;
    final primaryTextColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final secondaryTextColor =
        theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.white70;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.75, // "Half" side panel
        backgroundColor: theme.scaffoldBackgroundColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text("MENU",
                    style: GoogleFonts.spaceMono(
                        color: secondaryTextColor.withOpacity(0.5),
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(context, Icons.person_outline,
                        "Edit Profile", () => context.push('/edit-profile')),
                    _buildDrawerItem(context, Icons.attach_money, "Earnings",
                        () => context.push('/earnings')),
                    _buildDrawerItem(context, Icons.work_outline, "Experience",
                        () => context.push('/experience')),
                    _buildDrawerItem(context, Icons.settings_outlined,
                        "Settings", () => context.push('/settings')),
                    _buildDrawerItem(context, Icons.description_outlined,
                        "Terms & Conditions", () => context.push('/terms')),
                  ],
                ),
              ),
              Divider(color: theme.dividerColor),
              Padding(
                // Added significant bottom padding to clear any navigation bars
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                child: _buildDrawerItem(context, Icons.logout, "Log Out", () {
                  ref.read(authControllerProvider.notifier).logout();
                  context.go('/login');
                }, color: const Color(0xFFFF4C4C)),
              ),
            ],
          ),
        ),
      ),
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
              // Custom Unconventional Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              isDark
                                  ? Icons.light_mode_rounded
                                  : Icons.dark_mode_rounded,
                              color: theme.iconTheme.color,
                            ),
                            onPressed: () {
                              ref.read(themeProvider.notifier).setTheme(
                                    isDark ? ThemeMode.light : ThemeMode.dark,
                                  );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.drag_handle_rounded,
                                color: theme.iconTheme.color, size: 28),
                            onPressed: () =>
                                _scaffoldKey.currentState?.openEndDrawer(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Identity Block (Asymmetric)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Avatar Container
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF4F46E5),
                                    Color(0xFF818CF8)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF4F46E5)
                                        .withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  )
                                ]),
                            child: Center(
                              child: Text(
                                userInitial,
                                style: GoogleFonts.outfit(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ).animate().fadeIn().slideX(begin: -0.2),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  username,
                                  style: GoogleFonts.outfit(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: primaryTextColor,
                                    height: 1.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )
                                    .animate()
                                    .fadeIn(delay: 200.ms)
                                    .slideY(begin: 0.2),
                                const SizedBox(height: 6),
                                userStatsAsync.when(
                                  data: (stats) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: theme.brightness == Brightness.dark
                                          ? Colors.white.withOpacity(0.08)
                                          : Colors.black.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: theme.dividerColor),
                                    ),
                                    child: Text(
                                      "LEVEL ${stats.level} // ${stats.rank.toUpperCase()}",
                                      style: GoogleFonts.spaceMono(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF06B6D4),
                                      ),
                                    ),
                                  ).animate().fadeIn(delay: 400.ms),
                                  loading: () => const SizedBox(),
                                  error: (_, __) => const SizedBox(),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SliverGap(40),

              // 3. Stats "Control Panel"
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                          color: theme.dividerColor.withOpacity(0.06)),
                    ),
                    child: userStatsAsync.when(
                      data: (stats) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem(
                              context,
                              "STREAK",
                              "${stats.completedDrops > 0 ? 7 : 0} Days",
                              const Color(0xFFFF4C4C)),
                          Container(
                              width: 1, height: 40, color: theme.dividerColor),
                          _buildStatItem(context, "EXP", "${stats.totalXp} XP",
                              const Color(0xFFEAB308)),
                          Container(
                              width: 1, height: 40, color: theme.dividerColor),
                          _buildStatItem(
                              context,
                              "DROPS",
                              "${stats.completedDrops}",
                              const Color(0xFF06B6D4)),
                        ],
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const SizedBox(),
                    ),
                  ).animate().fadeIn(delay: 600.ms).scale(),
                ),
              ),

              const SliverGap(40),

              // 4. Skills "Matrix"
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(context, "SKILL MATRIX"),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _buildSkillBadge(context, "Flutter", 0.9),
                          _buildSkillBadge(context, "Dart", 0.85),
                          _buildSkillBadge(context, "Python", 0.7),
                          _buildSkillBadge(context, "System Design", 0.6),
                          _buildSkillBadge(context, "UI/UX", 0.8),
                        ],
                      )
                    ],
                  ).animate().fadeIn(delay: 800.ms),
                ),
              ),

              const SliverGap(40),

              // 5. Experience Timeline (Custom Design)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(context, "CAREER PATH"),
                      const SizedBox(height: 20),
                      // Timeline
                      _buildExpNode(context, "Senior AI Engineer", "Tesla",
                          "2023 - Present", true, false),
                      _buildExpNode(context, "Frontend Engineer", "Google",
                          "2021 - 2023", false, false),
                      _buildExpNode(context, "Mobile Developer", "Startups",
                          "2019 - 2021", false, true),
                    ],
                  ).animate().fadeIn(delay: 1000.ms),
                ),
              ),

              const SliverGap(40),

              // 6. Contribution Graph (The "Footer")
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(context, "ACTIVITY MAP"),
                      const SizedBox(height: 20),
                      HeatMap(
                        datasets: _heatMapDatasets,
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
                        startDate:
                            DateTime.now().subtract(const Duration(days: 60)),
                        endDate: DateTime.now(),
                        size: 20,
                        textColor:
                            theme.textTheme.bodySmall?.color?.withOpacity(0.3),
                      )
                    ],
                  ).animate().fadeIn(delay: 1200.ms),
                ),
              ),

              const SliverGap(80),
            ],
          ),
        ],
      ),
    );
  }

  // --- Design System Widgets ---

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.textTheme.bodyLarge?.color;

    return ListTile(
      leading: Icon(icon, color: effectiveColor, size: 22),
      title: Text(title,
          style: GoogleFonts.outfit(
              fontSize: 16,
              color: effectiveColor,
              fontWeight: FontWeight.w500)),
      onTap: onTap,
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

  Widget _buildStatItem(
      BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 6,
                height: 6,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.spaceMono(
                  fontSize: 10,
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillBadge(BuildContext context, String label, double mastery) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Custom modern pill with partial fill background
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF18181B) : Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          // Mini progress bar
          Container(
            width: 30,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: mastery,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.lerp(const Color(0xFF06B6D4),
                      const Color(0xFF4F46E5), mastery),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          )
        ],
      ),
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
