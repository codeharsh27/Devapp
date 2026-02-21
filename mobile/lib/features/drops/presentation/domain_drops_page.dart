import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../domain/drop.dart';
import 'drops_provider.dart';

class DomainDropsPage extends ConsumerWidget {
  final String domainId;
  const DomainDropsPage({super.key, required this.domainId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropsAsync = ref.watch(dropsListProvider);
    // final theme = Theme.of(context);

    // Domain Metadata
    final domainMap = {
      'backend': const {
        'title': 'Backend Systems',
        'color': Color(0xFF00FF94),
        'icon': Icons.dns_rounded
      },
      'frontend': const {
        'title': 'Frontend Engineering',
        'color': Color(0xFF00E0FF),
        'icon': Icons.palette_rounded
      },
      'mobile': const {
        'title': 'Mobile Development',
        'color': Color(0xFFFFB800),
        'icon': Icons.smartphone_rounded
      },
      'cloud': const {
        'title': 'Cloud Infrastructure',
        'color': Color(0xFF2979FF),
        'icon': Icons.cloud_upload_rounded
      },
      'ai': const {
        'title': 'Artificial Intelligence',
        'color': Color(0xFFAA00FF),
        'icon': Icons.psychology_rounded
      },
      'design': const {
        'title': 'Product Design',
        'color': Color(0xFFFF3D00),
        'icon': Icons.brush_rounded
      },
    };

    final meta = domainMap[domainId.toLowerCase()] ??
        const {
          'title': 'UNKNOWN', // Fallback title
          'color': Colors.white,
          'icon': Icons.work
        };
    final domainColor = meta['color'] as Color;
    final domainTitle = meta['title'] as String;
    final domainIcon = meta['icon'] as IconData;

    return Scaffold(
      backgroundColor: Colors.black, // Immersive Dark Mode
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: domainColor.withValues(alpha: 0.15),
                boxShadow: [
                  BoxShadow(
                    color: domainColor.withValues(alpha: 0.2),
                    blurRadius: 150,
                    spreadRadius: 50,
                  )
                ],
              ),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                // AppBar
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  floating: true,
                  leading: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18, color: Colors.white),
                    ),
                    onPressed: () => context.pop(),
                  ),
                  centerTitle: true,
                  title: Text(
                    domainTitle.toUpperCase(),
                    style: GoogleFonts.spaceMono(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  actions: [
                    Icon(domainIcon, color: domainColor.withValues(alpha: 0.8)),
                    const SizedBox(width: 20),
                  ],
                ),

                // Content
                dropsAsync.when(
                  data: (drops) {
                    final filteredDrops = drops
                        .where((d) =>
                            d.domain.toLowerCase() == domainId.toLowerCase())
                        .toList();

                    if (filteredDrops.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.perm_scan_wifi_rounded,
                                  size: 64,
                                  color: Colors.white.withValues(alpha: 0.2)),
                              const SizedBox(height: 20),
                              Text(
                                "NO ACTIVE PROTOCOLS",
                                style: GoogleFonts.spaceMono(
                                  color: Colors.white54,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final drop = filteredDrops[index];
                            return DomainDropCard(
                                    drop: drop, color: domainColor)
                                .animate()
                                .slideY(begin: 0.1, delay: (50 * index).ms)
                                .fadeIn();
                          },
                          childCount: filteredDrops.length,
                        ),
                      ),
                    );
                  },
                  loading: () => const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator())),
                  error: (e, _) => SliverFillRemaining(
                      child: Center(child: Text("Error: $e"))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DomainDropCard extends StatelessWidget {
  final Drop drop;
  final Color color;

  const DomainDropCard({super.key, required this.drop, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/drop', extra: drop),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: const Color(
                0xFF141414), // Solid dark background for performance & clean look
            padding: const EdgeInsets.all(1), // Border width
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: color.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          "${drop.rewardXp} XP",
                          style: GoogleFonts.spaceMono(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),

                      // Difficulty Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          drop.difficulty.toUpperCase(),
                          style: GoogleFonts.spaceMono(
                            color: drop.difficulty.toLowerCase() == 'hard'
                                ? const Color(0xFFFF3D00)
                                : Colors.white.withValues(alpha: 0.7),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    drop.title,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    drop.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 14, color: Colors.white.withValues(alpha: 0.4)),
                      const SizedBox(width: 6),
                      Text(
                        "${drop.timeLimitMinutes} MIN",
                        style: GoogleFonts.spaceMono(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
