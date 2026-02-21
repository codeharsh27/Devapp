import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'drops_provider.dart';
import 'current_drop_provider.dart';
import 'dart:ui'; // For BackdropFilter

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("TASK PROGRESS",
            style: GoogleFonts.spaceMono(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 2,
                color: theme.textTheme.titleLarge?.color)),
        backgroundColor:
            theme.scaffoldBackgroundColor.withValues(alpha: 0.8), // Glassy-ish
        foregroundColor: theme.iconTheme.color,
        centerTitle: true,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF00C853),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: const Color(0xFF00C853),
          unselectedLabelColor: theme.disabledColor,
          labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "ACTIVE"),
            Tab(text: "HISTORY"),
            Tab(text: "SAVED"),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Dynamic Background (reused from Home)
          if (isDark) ...[
            Positioned(
              top: 100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent.withValues(alpha: 0.08),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withValues(alpha: 0.15),
                      blurRadius: 120,
                      spreadRadius: 60,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              right: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00C853).withValues(alpha: 0.05),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00C853).withValues(alpha: 0.1),
                      blurRadius: 100,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
            // 3. Light Overlay for contrast
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.4),
              ),
            ),
          ],

          TabBarView(
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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.disabledColor.withValues(alpha: 0.1)),
              child: Icon(Icons.layers_clear_outlined,
                  size: 48, color: theme.disabledColor),
            ),
            const SizedBox(height: 16),
            Text("NO ACTIVE OPERATIONS",
                style: GoogleFonts.spaceMono(
                    color: theme.textTheme.titleLarge?.color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5)),
            const SizedBox(height: 8),
            Text("Check Command Center for new intel.",
                style: GoogleFonts.outfit(
                    color: theme.textTheme.bodyMedium?.color
                        ?.withValues(alpha: 0.6))),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
          24, 180, 24, 24), // Adjusted for pinned AppBar
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: const Color(0xFF00C853)
                    .withValues(alpha: activeDrop != null ? 0.5 : 0.1)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00C853).withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
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
                          color: const Color(0xFF00C853).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFF00C853)
                                  .withValues(alpha: 0.3))),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00C853),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text("LIVE EXECUTION",
                              style: GoogleFonts.spaceMono(
                                  color: const Color(0xFF00C853),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1)),
                        ],
                      ),
                    ),
                    Icon(Icons.more_horiz,
                        color: theme.iconTheme.color?.withValues(alpha: 0.5)),
                  ],
                ),
                const SizedBox(height: 24),
                Text(activeDrop.title,
                    style: GoogleFonts.outfit(
                        color: theme.textTheme.titleLarge?.color,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.2)),
                const SizedBox(height: 8),
                Text("Time is ticking. Complete the objective.",
                    style: GoogleFonts.outfit(
                        color: theme.textTheme.bodyMedium?.color
                            ?.withValues(alpha: 0.7))),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/execution', extra: activeDrop);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C853),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        child: Text("CONTINUE",
                            style: GoogleFonts.spaceMono(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5)),
                      ),
                    ),
                  ],
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
        child: Text("NO PRIOR LOGS",
            style: GoogleFonts.spaceMono(
                color: theme.disabledColor, letterSpacing: 2)));
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
                    size: 48, color: theme.disabledColor),
                const SizedBox(height: 16),
                Text("NO SAVED INTEL",
                    style: GoogleFonts.spaceMono(
                        color: theme.textTheme.titleLarge?.color,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5)),
                const SizedBox(height: 8),
                Text("Mark missions for future execution.",
                    style: GoogleFonts.outfit(
                        color: theme.textTheme.bodyMedium?.color
                            ?.withValues(alpha: 0.6))),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 180, 24, 24),
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
