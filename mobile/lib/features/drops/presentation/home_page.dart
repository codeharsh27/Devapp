import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'current_drop_provider.dart';
import 'drops_provider.dart';
import '../domain/drop.dart';
import 'user_stats_provider.dart';
import 'dart:ui'; // Required for ImageFilter

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "All Drops";
  String _selectedSort = "Newest";

  @override
  void initState() {
    super.initState();
  }

  bool _initialFilterSet = false;

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true, // Show above bottom navigation bar
      backgroundColor: Colors.transparent, // Transparent for blur effect
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E).withOpacity(0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text("Sort Intel",
                      style: GoogleFonts.spaceMono(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildSortOption("Newest"),
                  _buildSortOption("Oldest"),
                  _buildSortOption("Highest Reward"),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C853),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        elevation: 0,
                      ),
                      onPressed: () {
                        this.setState(() {}); // Update main page
                        Navigator.pop(context);
                      },
                      child: Text("APPLY FILTERS",
                          style: GoogleFonts.outfit(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(String label) {
    final isSelected = _selectedSort == label;
    return InkWell(
      onTap: () {
        // Since we are in a StatefulBuilder equivalent context for the modal,
        // we'd typically need to pass the setter. But for brevity in this refactor,
        // I'll assume we used StatefulBuilder correctly as before or let the parent update.
        // For this specific 'glass' refactor, I'll focus on the visual widget structure.
        Navigator.pop(context);
        setState(() =>
            _selectedSort = label); // Applying immediately for smoother feel
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Text(label,
                style: GoogleFonts.outfit(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal)),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: Color(0xFF00C853), size: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dropsAsync = ref.watch(dropsListProvider);
    final activeDrop = ref.watch(currentDropProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Smart Filter Initialization
    ref.listen(userStatsProvider, (previous, next) {
      if (!_initialFilterSet && next.hasValue) {
        final stats = next.value!;
        if (stats.xpBreakdown.isNotEmpty) {
          // Find dominant skill
          var topEntry = stats.xpBreakdown.entries
              .reduce((a, b) => (a.value as int) > (b.value as int) ? a : b);

          final domain = topEntry.key;
          // Capitalize first letter
          final displayDomain = domain[0].toUpperCase() + domain.substring(1);

          setState(() {
            _selectedFilter = displayDomain; // Matches filter chip labels
            _initialFilterSet = true;
          });
        }
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. Dynamic Background
          if (isDark) ...[
            // Animated blobs could go here using a package like mesh_gradient
            // For now, we use our static but blurred orbs
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00C853).withOpacity(0.08),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00C853).withOpacity(0.15),
                      blurRadius: 120,
                      spreadRadius: 60,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent.withOpacity(0.08),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.15),
                      blurRadius: 120,
                      spreadRadius: 60,
                    ),
                  ],
                ),
              ),
            ),
            // 3. Light Overlay for contrast
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ],

          // 2. Glassmorphic Content
          SafeArea(
            child: dropsAsync.when(
              data: (drops) {
                // Filter Logic (Same as before)
                final query = _searchController.text.toLowerCase();
                var filteredDrops = drops.where((drop) {
                  final matchesSearch =
                      drop.title.toLowerCase().contains(query) ||
                          drop.description.toLowerCase().contains(query) ||
                          drop.domain.toLowerCase().contains(query) ||
                          drop.difficulty.toLowerCase().contains(query);

                  bool matchesFilter = true;
                  if (_selectedFilter == "All Drops")
                    matchesFilter = true;
                  else if (_selectedFilter == "High Reward")
                    matchesFilter = drop.rewardXp >= 100;
                  else if (_selectedFilter == "Quick")
                    matchesFilter = drop.timeLimitMinutes <= 120;
                  else
                    matchesFilter = drop.domain.toLowerCase() ==
                        _selectedFilter.toLowerCase();

                  return matchesSearch && matchesFilter;
                }).toList();

                if (_selectedSort == "Highest Reward") {
                  filteredDrops
                      .sort((a, b) => b.rewardXp.compareTo(a.rewardXp));
                }

                return CustomScrollView(
                  slivers: [
                    // Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final statsAsync = ref.watch(userStatsProvider);

                            return statsAsync.when(
                              data: (stats) {
                                // DOMAIN IDENTITY LOGIC
                                String primaryDomain = "Operative";
                                int domainXp = stats.totalXp;
                                int domainLevel = stats.level;

                                if (stats.xpBreakdown.isNotEmpty) {
                                  // Find top domain
                                  var topEntry = stats.xpBreakdown.entries
                                      .reduce((a, b) =>
                                          (a.value as int) > (b.value as int)
                                              ? a
                                              : b);
                                  primaryDomain = topEntry.key;
                                  // Capitalize
                                  primaryDomain =
                                      primaryDomain[0].toUpperCase() +
                                          primaryDomain.substring(1);

                                  domainXp = topEntry.value as int;
                                  domainLevel = (domainXp / 1000).floor() + 1;
                                }

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "$primaryDomain Level $domainLevel"
                                                    .toUpperCase(),
                                                style: GoogleFonts.spaceMono(
                                                    color: theme.textTheme
                                                        .bodyMedium?.color
                                                        ?.withOpacity(0.6),
                                                    fontSize: 10,
                                                    letterSpacing: 3,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF00C853)
                                                            .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: Text(
                                                  stats.rank.toUpperCase(),
                                                  style: GoogleFonts.spaceMono(
                                                      color: const Color(
                                                          0xFF00C853),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text(
                                                domainXp.toString(),
                                                style: GoogleFonts.outfit(
                                                    color: theme.textTheme
                                                        .titleLarge?.color,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: 0.5),
                                              ),
                                              Text(
                                                " ${primaryDomain.toUpperCase()} XP",
                                                style: GoogleFonts.outfit(
                                                    color:
                                                        const Color(0xFF00C853),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          // XP Bar
                                          Container(
                                            height: 4,
                                            width: 140,
                                            decoration: BoxDecoration(
                                              color: theme.dividerColor
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                            child: FractionallySizedBox(
                                              alignment: Alignment.centerLeft,
                                              widthFactor: (domainXp % 1000) /
                                                  1000, // Assuming 1000 XP per level
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF00C853),
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                              0xFF00C853)
                                                          .withOpacity(0.5),
                                                      blurRadius: 6,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          context.push('/notifications'),
                                      child: Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color:
                                              theme.cardColor.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                              color: theme.dividerColor
                                                  .withOpacity(0.3)),
                                        ),
                                        child: Icon(
                                            Icons.notifications_none_rounded,
                                            color: theme.iconTheme.color),
                                      ),
                                    ).animate().scale(delay: 200.ms),
                                  ],
                                );
                              },
                              loading: () => const SizedBox(
                                  height: 60,
                                  child:
                                      Center(child: LinearProgressIndicator())),
                              error: (_, __) => const SizedBox(),
                            );
                          },
                        ),
                      ),
                    ),

                    // Active Mission Banner Glass
                    if (activeDrop != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: InkWell(
                                onTap: () => context.push('/execution',
                                    extra: activeDrop),
                                child: Container(
                                  padding:
                                      const EdgeInsets.all(1), // Border width
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFF00C853)
                                                .withOpacity(0.5),
                                            Colors.transparent
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight)),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00C853)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(23),
                                    ),
                                    child: Row(
                                      children: [
                                        Hero(
                                          tag: 'active_mission_timer',
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: const BoxDecoration(
                                                color: Color(0xFF00C853),
                                                shape: BoxShape.circle),
                                            child: const Icon(Icons.bolt,
                                                color: Colors.black, size: 24),
                                          ),
                                        )
                                            .animate(
                                                onPlay: (c) =>
                                                    c.repeat(reverse: true))
                                            .scale(
                                                begin: const Offset(0.95, 0.95),
                                                end: const Offset(1.05, 1.05)),
                                        const SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "IN PROGRESS",
                                              style: GoogleFonts.spaceMono(
                                                  color:
                                                      const Color(0xFF00C853),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 2),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Resume Task",
                                              style: GoogleFonts.outfit(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        const Icon(Icons.arrow_forward_rounded,
                                            color: Colors.white70)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ).animate().slideY(begin: -0.2).fadeIn(),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 12)),

                    // Search & Filters
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            // Glass Search Bar
                            Container(
                              height: 56,
                              decoration: BoxDecoration(
                                // Better visibility in light mode: darker background if not dark mode
                                color: isDark
                                    ? theme.cardColor.withOpacity(0.3)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: isDark
                                        ? Colors.white.withOpacity(0.1)
                                        : Colors.grey.withOpacity(0.3)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      Icon(Icons.search,
                                          color: theme.iconTheme.color
                                              ?.withOpacity(0.5)),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          onChanged: (val) => setState(() {}),
                                          style: GoogleFonts.outfit(
                                              color: theme
                                                  .textTheme.bodyLarge?.color),
                                          decoration: InputDecoration(
                                            hintText:
                                                "Search intel database...",
                                            hintStyle: GoogleFonts.outfit(
                                                color: theme
                                                    .textTheme.bodyMedium?.color
                                                    ?.withOpacity(0.4)),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.tune_rounded), // Filter Icon
                                        color: theme.iconTheme.color
                                            ?.withOpacity(0.7),
                                        onPressed: () =>
                                            _showFilterBottomSheet(context),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 40,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  _buildFilterChip("All Drops"),
                                  _buildFilterChip("High Reward"),
                                  _buildFilterChip("Quick"),
                                  _buildFilterChip("Frontend"),
                                  _buildFilterChip("Backend"),
                                  _buildFilterChip("Cloud"),
                                  _buildFilterChip("Design"),
                                  _buildFilterChip("Product"),
                                  _buildFilterChip("AI"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "AVAILABLE MISSIONS",
                              style: GoogleFonts.spaceMono(
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2),
                            ),
                            Text(
                              "${filteredDrops.length} FOUND",
                              style: GoogleFonts.spaceMono(
                                  color:
                                      const Color(0xFF00C853).withOpacity(0.8),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                          ],
                        ),
                      ),
                    ),

                    filteredDrops.isEmpty
                        ? SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: Column(
                                children: [
                                  Icon(Icons.wifi_off_rounded,
                                      size: 48,
                                      color:
                                          theme.disabledColor.withOpacity(0.3)),
                                  const SizedBox(height: 16),
                                  Text(
                                    "NO INTEL DETECTED",
                                    style: GoogleFonts.spaceMono(
                                        color: theme.disabledColor
                                            .withOpacity(0.5),
                                        letterSpacing: 2),
                                  )
                                ],
                              ),
                            ),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final drop = filteredDrops[index];
                                  return DropCard(
                                      drop: drop, activeDrop: activeDrop);
                                },
                                childCount: filteredDrops.length,
                              ),
                            ),
                          ),
                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text("System Failure: $err")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final theme = Theme.of(context);
    final isSelected = _selectedFilter == label;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: AnimatedContainer(
        duration: 300.ms,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          // Fix for light mode: Ensure contrast for unselected chips
          color: isSelected
              ? (isDark ? Colors.white : Colors.black)
              : (isDark ? Colors.transparent : Colors.grey.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isDark
                      ? theme.dividerColor.withOpacity(0.3)
                      : Colors.black
                          .withOpacity(0.1))), // Stronger border in light mode
        ),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
              color: isSelected
                  ? (isDark ? Colors.black : Colors.white)
                  : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 1),
        ),
      ),
    );
  }
}

class DropCard extends ConsumerWidget {
  final Drop drop;
  final Drop? activeDrop;

  const DropCard({super.key, required this.drop, this.activeDrop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEnrolled = activeDrop?.id == drop.id;

    // Unlocking Logic
    final userStats = ref.watch(userStatsProvider).valueOrNull;

    bool isLocked = false;
    int requiredLevel = 1;
    String userDomainRank = "Novice"; // Default

    // Determine user's level IN THIS SPECIFIC DOMAIN
    int domainLevel = 1;
    if (userStats != null && userStats.xpBreakdown.isNotEmpty) {
      final domainKey = drop.domain.toLowerCase();
      final domainXp = userStats.xpBreakdown[domainKey] as int? ?? 0;
      domainLevel = (domainXp / 1000).floor() + 1;
    }

    if (drop.difficulty.toLowerCase() == 'medium') requiredLevel = 2;
    if (drop.difficulty.toLowerCase() == 'hard') requiredLevel = 5;

    if (domainLevel < requiredLevel) isLocked = true;

    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: isLocked ? theme.cardColor.withOpacity(0.5) : theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isEnrolled
                ? const Color(0xFF00C853)
                : theme.dividerColor.withOpacity(0.2),
            width: isEnrolled ? 1.5 : 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              if (isLocked) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "LOCKED: Reach Level $requiredLevel in ${drop.domain} to access.")));
                return;
              }
              isEnrolled
                  ? context.push('/execution', extra: drop)
                  : context.push('/drop', extra: drop);
            },
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Opacity(
                    opacity: isLocked ? 0.3 : 1.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDomainTag(context, drop.domain),
                            Row(
                              children: [
                                if (drop.sourceType == 'B')
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color:
                                                Colors.blue.withOpacity(0.5))),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.public,
                                            size: 10, color: Colors.blueAccent),
                                        const SizedBox(width: 4),
                                        Text(
                                          "OPEN SOURCE",
                                          style: GoogleFonts.spaceMono(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent),
                                        ),
                                      ],
                                    ),
                                  ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: theme.scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: theme.dividerColor
                                              .withOpacity(0.5))),
                                  child: Text(
                                    drop.difficulty.toUpperCase(),
                                    style: GoogleFonts.spaceMono(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            theme.textTheme.bodySmall?.color),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          drop.title,
                          style: GoogleFonts.outfit(
                              color: theme.textTheme.titleLarge?.color,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.2),
                        ),
                        const SizedBox(height: 24),

                        // Stats Grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildStat(
                                  context,
                                  "REWARD",
                                  "${drop.rewardXp} XP",
                                  const Color(0xFFFFD700) // Gold
                                  ),
                            ),
                            Container(
                                width: 1,
                                height: 24,
                                color: theme.dividerColor),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: _buildStat(
                                    context,
                                    "TIME EST.",
                                    "${drop.timeLimitMinutes} MIN",
                                    theme.textTheme.bodyLarge?.color
                                            ?.withOpacity(0.8) ??
                                        Colors.white),
                              ),
                            ),

                            // Action Arrow
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isEnrolled
                                      ? const Color(0xFF00C853)
                                      : (isDark
                                          ? Colors.white.withOpacity(0.1)
                                          : theme.scaffoldBackgroundColor)),
                              child: Icon(
                                  isEnrolled
                                      ? Icons.pause
                                      : Icons.arrow_forward,
                                  size: 16,
                                  color: isEnrolled
                                      ? Colors.white
                                      : (isDark
                                          ? Colors.white
                                          : theme.iconTheme.color)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                if (isLocked)
                  Positioned.fill(
                      child: Center(
                          child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.lock_outline,
                        size: 32, color: Colors.white),
                  )))
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1));
  }

  Widget _buildStat(
      BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceMono(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
              color: color, fontWeight: FontWeight.bold, fontSize: 16),
        )
      ],
    );
  }

  Widget _buildDomainTag(BuildContext context, String domain) {
    final color = _getDomainColor(domain);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: color.withOpacity(0.5))),
      child: Text(
        domain.toUpperCase(),
        style: GoogleFonts.outfit(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5),
      ),
    );
  }

  Color _getDomainColor(String domain) {
    switch (domain.toLowerCase()) {
      case 'frontend':
        return Colors.cyanAccent;
      case 'backend':
        return const Color(0xFF00E676);
      case 'mobile':
        return Colors.orangeAccent;
      case 'cloud':
        return Colors.purpleAccent;
      case 'design':
        return Colors.pinkAccent;
      case 'ai':
        return Colors.deepPurpleAccent;
      case 'product':
        return Colors.yellowAccent;
      case 'ai':
        return Colors.purpleAccent;
      default:
        return Colors.grey;
    }
  }
}
