import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'current_drop_provider.dart';
import 'drops_provider.dart';
import '../domain/drop.dart';

import 'package:flutter_animate/flutter_animate.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "All Drops";
  String _selectedSort = "Newest";

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sort By",
                    style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildSortOption("Newest", setStateModal),
                _buildSortOption("Oldest", setStateModal),
                _buildSortOption("Highest Reward", setStateModal),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      this.setState(() {}); // Update main page
                      Navigator.pop(context);
                    },
                    child: Text("Apply Filters",
                        style: GoogleFonts.outfit(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortOption(String label, StateSetter setStateModal) {
    final isSelected = _selectedSort == label;
    return InkWell(
      onTap: () {
        setStateModal(() => _selectedSort = label);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Text(label,
                style: GoogleFonts.outfit(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontSize: 16)),
            const Spacer(),
            if (isSelected) const Icon(Icons.check, color: Colors.blueAccent),
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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: theme.dividerColor,
              child: Icon(Icons.person, color: theme.iconTheme.color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good Afternoon",
                  style: GoogleFonts.outfit(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                Text(
                  "DevApp Agent",
                  style: GoogleFonts.outfit(
                    color: theme.textTheme.titleLarge?.color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => context.push('/notifications'),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.dividerColor),
              ),
              child: Icon(Icons.notifications_outlined,
                  color: theme.iconTheme.color, size: 24),
            ),
          ).animate().scale(delay: 300.ms),
        ],
      ),
      body: dropsAsync.when(
        data: (drops) {
          // Filter Logic
          final query = _searchController.text.toLowerCase();
          var filteredDrops = drops.where((drop) {
            // Enhanced Search
            final matchesSearch = drop.title.toLowerCase().contains(query) ||
                drop.description.toLowerCase().contains(query) ||
                drop.domain.toLowerCase().contains(query) ||
                drop.difficulty.toLowerCase().contains(query);

            bool matchesFilter = true;
            if (_selectedFilter == "All Drops") {
              matchesFilter = true;
            } else if (_selectedFilter == "High Reward") {
              matchesFilter = drop.rewardXp >= 100;
            } else if (_selectedFilter == "Quick") {
              matchesFilter = drop.timeLimitMinutes <= 120;
            } else {
              matchesFilter =
                  drop.domain.toLowerCase() == _selectedFilter.toLowerCase();
            }

            return matchesSearch && matchesFilter;
          }).toList();

          // Sorting
          if (_selectedSort == "Highest Reward") {
            filteredDrops.sort((a, b) => b.rewardXp.compareTo(a.rewardXp));
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Minimalist Search Bar
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: theme.dividerColor.withOpacity(0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Icon(Icons.search_rounded,
                                color: theme.iconTheme.color?.withOpacity(0.5),
                                size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (val) {
                                  setState(() {});
                                },
                                style: GoogleFonts.outfit(
                                    color: theme.textTheme.bodyLarge?.color,
                                    fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: "Search missions...",
                                  hintStyle: GoogleFonts.outfit(
                                      color: theme.textTheme.bodyMedium?.color
                                          ?.withOpacity(0.5),
                                      fontSize: 14),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            Container(
                              height: 24,
                              width: 1,
                              color: theme.dividerColor,
                            ),
                            InkWell(
                              onTap: () => _showFilterBottomSheet(context),
                              borderRadius: BorderRadius.circular(24),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Icon(Icons.tune_rounded,
                                    color:
                                        theme.iconTheme.color?.withOpacity(0.7),
                                    size: 18),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                      const SizedBox(height: 24),

                      // Filters
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
                          ],
                        ),
                      ).animate().fadeIn(delay: 400.ms),
                      const SizedBox(height: 32),

                      // List Header
                      Text(
                        "Recommendation For you",
                        style: GoogleFonts.outfit(
                          color: theme.textTheme.titleLarge?.color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              filteredDrops.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Text("No jobs found",
                              style: GoogleFonts.outfit(
                                  color: theme.disabledColor)),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final drop = filteredDrops[index];
                            return DropCard(drop: drop, activeDrop: activeDrop);
                          },
                          childCount: filteredDrops.length,
                        ),
                      ),
                    ),
              // Bottom Padding for Floating Navbar
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text("Error: $err", style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final theme = Theme.of(context);
    final isSelected = _selectedFilter == label;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : theme.primaryColor)
              : (isDark ? theme.cardColor : Colors.grey[200]),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: isSelected
                  ? (isDark ? Colors.white : theme.primaryColor)
                  : (isDark ? theme.dividerColor : Colors.grey[400]!)),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.outfit(
              color: isSelected
                  ? (isDark ? Colors.black : Colors.white)
                  : (isDark
                      ? theme.textTheme.bodyMedium?.color
                      : Colors.black87),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class DropCard extends StatelessWidget {
  final Drop drop;
  final Drop? activeDrop;

  const DropCard({super.key, required this.drop, this.activeDrop});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEnrolled = activeDrop?.id == drop.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor, // Minimalist Dark/Light
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isEnrolled
              ? Colors.blueAccent.withOpacity(0.4)
              : theme.dividerColor.withOpacity(0.5),
          width: isEnrolled ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => isEnrolled
              ? context.push('/execution', extra: drop)
              : context.push('/drop', extra: drop),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Meta: Domain Tag + Difficulty
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDomainPill(context, drop.domain),
                    Text(
                      drop.difficulty,
                      style: GoogleFonts.outfit(
                        color:
                            theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Main Title
                Text(
                  drop.title,
                  style: GoogleFonts.outfit(
                    color: theme.textTheme.titleLarge?.color,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),

                // Key Metrics (Reward & Time)
                Row(
                  children: [
                    _buildMetric(
                      context,
                      "REWARD",
                      "${drop.rewardXp} XP",
                      Icons.bolt_rounded,
                      const Color(0xFFD4E157), // Keep distinct lime green
                      // For light mode, maybe darken slightly? Kept for now as it pops.
                    ),
                    Container(
                      height: 32,
                      width: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      color: theme.dividerColor,
                    ),
                    _buildMetric(
                      context,
                      "TIME LIMIT",
                      "${drop.timeLimitMinutes} min",
                      Icons.timer_outlined,
                      theme.textTheme.bodyLarge?.color ?? Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Footer: Action Area
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Social Proof
                    // Social Proof - Contributors
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 30,
                            child: Stack(
                              children: [
                                // Mock Contributors with unique avatars
                                for (int i = 0; i < 3; i++)
                                  Positioned(
                                    left: i * 20.0,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: theme.cardColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: theme.cardColor, width: 2),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              'https://i.pravatar.cc/150?u=${drop.id * 10 + i}'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Text(
                              "+${(drop.id % 3) + 2}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withOpacity(0.6),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Minimal Action Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10), // Reduced padding
                      decoration: BoxDecoration(
                        color: isEnrolled
                            ? Colors.blueAccent
                            : (isDark ? Colors.white : Colors.black),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Text(
                            isEnrolled ? "Enrolled" : "Start Task",
                            style: GoogleFonts.outfit(
                              color: isEnrolled
                                  ? Colors.white
                                  : (isDark ? Colors.black : Colors.white),
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                              isEnrolled
                                  ? Icons.play_arrow_rounded
                                  : Icons.arrow_forward_rounded,
                              size: 16,
                              color: isEnrolled
                                  ? Colors.white
                                  : (isDark ? Colors.black : Colors.white)),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, curve: Curves.easeOut);
  }

  Widget _buildMetric(BuildContext context, String label, String value,
      IconData icon, Color accentColor) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
            fontSize: 10,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(icon, color: accentColor, size: 18),
            const SizedBox(width: 6),
            Text(
              value,
              style: GoogleFonts.outfit(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDomainPill(BuildContext context, String domain) {
    Color color = _getDomainColor(domain);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        // In light mode, use a stronger opacity for the background
        color: color.withOpacity(isDark ? 0.1 : 0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(isDark ? 0.2 : 0.5)),
      ),
      child: Text(
        domain.toUpperCase(),
        style: GoogleFonts.outfit(
          // In light mode, darken the text color slightly if it's too light
          color: isDark
              ? color
              : HSLColor.fromColor(color).withLightness(0.35).toColor(),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getDomainColor(String domain) {
    switch (domain.toLowerCase()) {
      case 'frontend':
        return Colors.blueAccent;
      case 'backend':
        return Colors.greenAccent;
      case 'mobile':
        return Colors.orangeAccent;
      case 'ai':
        return Colors.purpleAccent;
      default:
        return Colors.grey;
    }
  }
}
