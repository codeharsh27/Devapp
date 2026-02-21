import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../domain/drop.dart';
import 'dart:math' as math;
import 'current_drop_provider.dart';
import '../data/drops_repository.dart';
import 'saved_drops_provider.dart';

import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class DropDetailPage extends ConsumerStatefulWidget {
  final Drop drop;
  const DropDetailPage({super.key, required this.drop});

  @override
  ConsumerState<DropDetailPage> createState() => _DropDetailPageState();
}

class _DropDetailPageState extends ConsumerState<DropDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeDrop = ref.watch(currentDropProvider);
    final isEnrolled = activeDrop?.id == widget.drop.id;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: theme.iconTheme.color,
          onPressed: () => context.pop(),
        ),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final savedDrops = ref.watch(savedDropsProvider);
              final isSaved = savedDrops.contains(widget.drop.id);
              final savedNotifier = ref.read(savedDropsProvider.notifier);

              return IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border_rounded,
                  color: isSaved ? theme.primaryColor : theme.iconTheme.color,
                  size: 26,
                ),
                onPressed: () {
                  savedNotifier.toggleSave(widget.drop.id);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isSaved
                            ? "Removed from Saved Tasks"
                            : "Task Saved Successfully",
                        style: GoogleFonts.outfit(),
                      ),
                      backgroundColor:
                          isSaved ? Colors.grey : theme.primaryColor,
                      duration: const Duration(milliseconds: 1500),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Meta
                    Row(
                      children: [
                        _buildDomainTag(widget.drop.domain),
                        const SizedBox(width: 12),
                        Container(
                            width: 1, height: 16, color: theme.dividerColor),
                        const SizedBox(width: 12),
                        Text(widget.drop.difficulty,
                            style: GoogleFonts.outfit(
                                color: theme.textTheme.bodySmall?.color,
                                fontSize: 14)),
                      ],
                    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      widget.drop.title,
                      style: GoogleFonts.outfit(
                        color: theme.textTheme.titleLarge?.color,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                    const SizedBox(height: 16),

                    // Description
                    Text("MISSION BRIEF",
                        style: GoogleFonts.outfit(
                            color: theme.textTheme.bodySmall?.color
                                ?.withValues(alpha: 0.8),
                            fontSize: 12,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    MarkdownBody(
                      data: widget.drop.description,
                      styleSheet: MarkdownStyleSheet(
                        p: GoogleFonts.outfit(
                          color: theme.textTheme.bodyMedium?.color,
                          fontSize: 16,
                          height: 1.6,
                          fontWeight: FontWeight.w300,
                        ),
                        h1: GoogleFonts.outfit(
                            color: theme.textTheme.titleLarge?.color,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                        h2: GoogleFonts.outfit(
                            color: theme.textTheme.titleLarge?.color,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        code: GoogleFonts.firaCode(
                          color:
                              isDark ? Colors.amberAccent : Colors.deepPurple,
                          backgroundColor: theme.cardColor
                              .withValues(alpha: 0.5), // Subtle code bg
                          fontSize: 14,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // --- NEW INTEL ASSETS SECTION ---
                    _buildIntelAssets(context, isDark),
                    const SizedBox(height: 32),

                    // Serious Warning Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            isDark ? const Color(0xFF2B0E0E) : Colors.red[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: isDark
                                ? Colors.redAccent.withValues(alpha: 0.3)
                                : Colors.redAccent.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: Colors.redAccent, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                "PROFESSIONAL INTEGRITY VALIDATION",
                                style: GoogleFonts.outfit(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "All code link, docs, and screenshots are manually analyzed by Hiring Managers and Founders. Fake or invalid submissions will result in immediate penalty and account blacklisting.",
                            style: GoogleFonts.outfit(
                              color: isDark ? Colors.white70 : Colors.red[900],
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 500.ms),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Bottom Action Area
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Secondary Action: Deploy to HQ
                  if (!isEnrolled) ...[
                    GestureDetector(
                      onTap: () async {
                        try {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Connecting to secure terminal...",
                                style: GoogleFonts.outfit()),
                            backgroundColor: Colors.black54,
                            duration: const Duration(seconds: 1),
                          ));

                          await ref
                              .read(dropsRepositoryProvider.notifier)
                              .deployDrop(widget.drop.id);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Row(children: [
                                const Icon(Icons.send_rounded,
                                    color: Colors.white, size: 16),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                      "Mission Briefing sent to your email terminal.",
                                      style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ]),
                              backgroundColor: const Color(0xFF2962FF),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ));
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Deployment Failed: $e"),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    theme.dividerColor.withValues(alpha: 0.1)),
                            borderRadius: BorderRadius.circular(16),
                            color: theme.cardColor.withValues(alpha: 0.3)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.desktop_mac_rounded,
                                size: 18, color: theme.primaryColor),
                            const SizedBox(width: 8),
                            Text("DEPLOY INTEL TO DESKTOP",
                                style: GoogleFonts.spaceMono(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                    letterSpacing: 1))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Primary Action
                  GestureDetector(
                    onTap: isEnrolled
                        ? () => context.push('/execution', extra: widget.drop)
                        : () => _showStartDialog(context),
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                        color: isEnrolled
                            ? const Color(0xFF00C853)
                            : (isDark ? Colors.white : Colors.black),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                              color: (isEnrolled
                                      ? const Color(0xFF00C853)
                                      : Colors.black)
                                  .withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 5))
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isEnrolled ? "CONTINUE MISSION" : "START EXECUTING",
                            style: GoogleFonts.outfit(
                                color: isEnrolled
                                    ? Colors.black
                                    : (isDark ? Colors.black : Colors.white),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                          const SizedBox(width: 12),
                          // Animated Arrows
                          if (!isEnrolled)
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildArrow(0),
                                    Transform.translate(
                                        offset: const Offset(-8, 0),
                                        child: _buildArrow(0.2)),
                                    Transform.translate(
                                        offset: const Offset(-16, 0),
                                        child: _buildArrow(0.4)),
                                  ],
                                );
                              },
                            )
                          else
                            const Icon(Icons.play_arrow_rounded,
                                color: Colors.black),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntelAssets(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("INTEL ASSETS",
            style: GoogleFonts.outfit(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8),
                fontSize: 12,
                letterSpacing: 2,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 100, // Fixed height for asset cards
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildAssetCard(context, Icons.insert_drive_file_outlined,
                  "Briefing\nDoc", "PDF • 2.4MB"),
              const SizedBox(width: 12),
              _buildAssetCard(context, Icons.image_outlined, "Design\nSystem",
                  "FIGMA • LINK"),
              const SizedBox(width: 12),
              _buildAssetCard(
                  context, Icons.api_rounded, "API\nAccess", "JSON • V2"),
              const SizedBox(width: 12),
              _buildAssetCard(
                  context, Icons.code_rounded, "Starter\nRepo", "GITHUB • TPL"),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildAssetCard(
      BuildContext context, IconData icon, String title, String subtitle) {
    final theme = Theme.of(context);
    return Container(
      width: 130,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon,
              color: theme.iconTheme.color?.withValues(alpha: 0.7), size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold, fontSize: 13, height: 1.1)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: GoogleFonts.spaceMono(
                      fontSize: 9,
                      color: theme.textTheme.bodySmall?.color
                          ?.withValues(alpha: 0.5))),
            ],
          )
        ],
      ),
    );
  }

  void _showStartDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated Pulse Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00C853).withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00C853).withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: const Icon(Icons.timer_outlined,
                    color: Color(0xFF00C853), size: 48),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 1.seconds),

              const SizedBox(height: 32),

              Text(
                "MISSION ACCEPTANCE",
                style: GoogleFonts.spaceMono(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Initialize Timer?",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Time Block
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.history_toggle_off,
                        color: Colors.white70, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      "${widget.drop.timeLimitMinutes} MINUTES",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              Text(
                "Once initialized, this mission session cannot be paused. Ensure your environment is ready for execution.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 48),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => context.pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text("ABORT",
                          style: GoogleFonts.outfit(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          )),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        // Start the mission tracking
                        ref
                            .read(currentDropProvider.notifier)
                            .setDrop(widget.drop);
                        Navigator.of(context).pop();
                        context.push('/execution', extra: widget.drop);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C853),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                        shadowColor:
                            const Color(0xFF00C853).withValues(alpha: 0.5),
                      ),
                      child: Text(
                        "EXECUTE",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArrow(double delay) {
    // Wave Effect Logic
    final double value = (_controller.value + delay) % 1.0;
    // Opacity peaks at 0.5 (sin wave style behavior)
    final double opacity = (math.sin(value * math.pi) * 0.7) + 0.3;

    return Opacity(
        opacity: opacity,
        child: const Icon(Icons.keyboard_arrow_right_rounded,
            color: Color(0xFF00C853), size: 24));
  }

  Widget _buildDomainTag(String domain) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _getDomainColor(domain).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
        border:
            Border.all(color: _getDomainColor(domain).withValues(alpha: 0.3)),
      ),
      child: Text(
        domain.toUpperCase(),
        style: GoogleFonts.outfit(
            color: _getDomainColor(domain),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1),
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
        return Colors.white;
    }
  }
} // End Class
