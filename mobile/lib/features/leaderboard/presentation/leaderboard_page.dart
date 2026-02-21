import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../drops/data/drops_repository.dart';
import '../../drops/domain/leaderboard_entry.dart';
import '../../profile/presentation/widgets/profile_drawer.dart';

final leaderboardProvider =
    FutureProvider.family<List<LeaderboardEntry>, String?>((ref, domain) async {
  return ref
      .watch(dropsRepositoryProvider.notifier)
      .getLeaderboard(domain: domain);
});

class LeaderboardPage extends ConsumerStatefulWidget {
  const LeaderboardPage({super.key});

  @override
  ConsumerState<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends ConsumerState<LeaderboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _domains = ["Global", "Design", "Code", "Product"];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _domains.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      endDrawer: const ProfileDrawer(),
      appBar: AppBar(
        title: Text("LEADERBOARD",
            style: GoogleFonts.spaceMono(
                color: theme.textTheme.titleLarge?.color,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: theme.iconTheme.color),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: theme.primaryColor,
          unselectedLabelColor: theme.textTheme.bodyMedium?.color,
          indicatorColor: theme.primaryColor,
          tabs: _domains.map((d) => Tab(text: d.toUpperCase())).toList(),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: _domains
              .map((domain) =>
                  _LeaderboardList(domain: domain == "Global" ? null : domain))
              .toList(),
        ),
      ),
    );
  }
}

class _LeaderboardList extends ConsumerWidget {
  final String? domain;
  const _LeaderboardList({this.domain});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider(domain));

    return leaderboardAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return Center(
              child: Text("No data yet.",
                  style: GoogleFonts.outfit(color: Colors.grey)));
        }

        // Split Top 3 and Rest
        final top3 = entries.take(3).toList();
        final rest = entries.skip(3).toList();

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(child: _buildPodium(context, top3)),
            ),
            const SliverGap(24),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = rest[index];
                    // Rank is index + 4
                    final rank = index + 4;
                    return _buildListItem(context, entry, rank);
                  },
                  childCount: rest.length,
                ),
              ),
            )
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Error: $e")),
    );
  }

  Widget _buildPodium(BuildContext context, List<LeaderboardEntry> top3) {
    // Ideally we arrange them 2 - 1 - 3
    // But list is sorted 1, 2, 3.
    // So visual order: entry[1], entry[0], entry[2] (if available)

    if (top3.isEmpty) return const SizedBox();

    final first = top3[0];
    final second = top3.length > 1 ? top3[1] : null;
    final third = top3.length > 2 ? top3[2] : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (second != null) _buildPodiumColumn(context, second, 2, 120),
        _buildPodiumColumn(context, first, 1, 160),
        if (third != null) _buildPodiumColumn(context, third, 3, 100),
      ],
    );
  }

  Widget _buildPodiumColumn(
      BuildContext context, LeaderboardEntry entry, int rank, double height) {
    final theme = Theme.of(context);
    final isFirst = rank == 1;
    final color = isFirst
        ? const Color(0xFFFFD700)
        : (rank == 2 ? const Color(0xFFC0C0C0) : const Color(0xFFCD7F32));

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Avatar + Crown Stack
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                  boxShadow: [
                    if (isFirst)
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 15,
                        spreadRadius: 1,
                      )
                  ],
                ),
                child: CircleAvatar(
                  radius: isFirst ? 32 : 24,
                  backgroundImage: entry.avatarUrl != null
                      ? NetworkImage(entry.avatarUrl!)
                      : const AssetImage('assets/profile_pic.jpg')
                          as ImageProvider,
                ),
              ),
              if (isFirst)
                Positioned(
                  top: -24,
                  child: const Icon(Icons.emoji_events_rounded,
                          color: Color(0xFFFFD700), size: 32)
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(begin: 0, end: -4, duration: 1200.ms),
                ),
            ],
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),

          const SizedBox(height: 12),

          Text(
            entry.fullName ?? "Guest",
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold, fontSize: isFirst ? 14 : 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            "${entry.totalXp} XP",
            style: GoogleFonts.spaceMono(
                fontSize: 10,
                color: theme.textTheme.bodySmall?.color,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Podium Block
          Container(
            height: height,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                border:
                    Border.all(color: color.withValues(alpha: 0.4), width: 1),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.3),
                    color.withValues(alpha: 0.05),
                  ],
                ),
                boxShadow: [
                  if (isFirst)
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    )
                ]),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text("#$rank",
                    style: GoogleFonts.spaceMono(
                        color: isFirst
                            ? Colors.white
                            : color.withValues(alpha: 0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        shadows: isFirst
                            ? [Shadow(color: color, blurRadius: 10)]
                            : null)),
              ],
            ),
          )
              .animate()
              .slideY(begin: 1, duration: 600.ms, curve: Curves.easeOutBack),
        ],
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context, LeaderboardEntry entry, int rank) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Text("#$rank",
              style: GoogleFonts.spaceMono(
                  fontWeight: FontWeight.bold, color: theme.disabledColor)),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 18,
            backgroundImage: entry.avatarUrl != null
                ? NetworkImage(entry.avatarUrl!)
                : const AssetImage('assets/profile_pic.jpg') as ImageProvider,
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.fullName ?? "Guest",
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
            ],
          )),
          Text("${entry.totalXp} XP",
              style: GoogleFonts.spaceMono(
                  color: theme.primaryColor, fontWeight: FontWeight.bold)),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }
}

class SliverGap extends StatelessWidget {
  final double size;
  const SliverGap(this.size, {super.key});
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: SizedBox(height: size));
  }
}
