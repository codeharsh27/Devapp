import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'drops_provider.dart';
import 'current_drop_provider.dart';

import 'saved_drops_provider.dart';
import 'home_page.dart'; // Import DropCard

class MyDropsPage extends ConsumerStatefulWidget {
  const MyDropsPage({super.key});

  @override
  ConsumerState<MyDropsPage> createState() => _MyDropsPageState();
}

class _MyDropsPageState extends ConsumerState<MyDropsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeDrop = ref.watch(currentDropProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Task Progress",
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color)),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.iconTheme.color,
        centerTitle: false,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blueAccent,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.blueAccent,
          unselectedLabelColor: theme.disabledColor,
          labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Enrolled"),
            Tab(text: "History"),
            Tab(text: "Saved"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Enrolled / Active Tab
          _buildEnrolledTab(activeDrop, theme, isDark),
          // History Tab
          _buildHistoryTab(theme),
          // Saved Tab
          _buildSavedTab(theme),
        ],
      ),
    );
  }

  Widget _buildEnrolledTab(activeDrop, ThemeData theme, bool isDark) {
    if (activeDrop == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.layers_clear_outlined,
                size: 60, color: theme.disabledColor),
            const SizedBox(height: 16),
            Text("No Active Mission",
                style: GoogleFonts.outfit(
                    color: theme.textTheme.titleLarge?.color, fontSize: 18)),
            const SizedBox(height: 8),
            Text("Go to Home to find your next challenge.",
                style: GoogleFonts.outfit(
                    color:
                        theme.textTheme.bodyMedium?.color?.withOpacity(0.7))),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text("CURRENT MISSION",
            style: GoogleFonts.outfit(
                color: theme.textTheme.bodySmall?.color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 2)),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.05),
                blurRadius: 20,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.circle,
                              color: Colors.redAccent, size: 8),
                          const SizedBox(width: 8),
                          Text("LIVE EXECUTION",
                              style: GoogleFonts.outfit(
                                  color: Colors.redAccent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Icon(Icons.more_horiz,
                        color: theme.iconTheme.color?.withOpacity(0.5)),
                  ],
                ),
                const SizedBox(height: 20),
                Text(activeDrop.title,
                    style: GoogleFonts.outfit(
                        color: theme.textTheme.titleLarge?.color,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Time is ticking...",
                    style: GoogleFonts.outfit(
                        color: theme.textTheme.bodyMedium?.color
                            ?.withOpacity(0.7))),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.push('/execution', extra: activeDrop);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Continue Mission"),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab(ThemeData theme) {
    return Center(
        child: Text("No history yet",
            style: TextStyle(color: theme.disabledColor)));
  }

  Widget _buildSavedTab(ThemeData theme) {
    final savedDrops = ref.watch(savedDropsProvider);
    final allDropsAsync = ref.watch(dropsListProvider);
    final activeDrop = ref.watch(currentDropProvider);

    return allDropsAsync.when(
      data: (drops) {
        final savedList =
            drops.where((drop) => savedDrops.contains(drop.id)).toList();

        if (savedList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border_rounded,
                    size: 60, color: theme.disabledColor),
                const SizedBox(height: 16),
                Text("No saved tasks",
                    style: GoogleFonts.outfit(
                        color: theme.textTheme.titleLarge?.color,
                        fontSize: 18)),
                const SizedBox(height: 8),
                Text("Tap the bookmark icon on any task to save it here.",
                    style: GoogleFonts.outfit(
                        color: theme.textTheme.bodyMedium?.color
                            ?.withOpacity(0.7))),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: savedList.length,
          itemBuilder: (context, index) {
            return DropCard(drop: savedList[index], activeDrop: activeDrop);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text("Failed to load saved drops")),
    );
  }
}
