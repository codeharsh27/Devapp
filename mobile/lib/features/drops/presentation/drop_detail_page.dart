import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../domain/drop.dart';
import 'dart:math' as math;
import 'current_drop_provider.dart';

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

                    // Contributors
                    Row(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 30,
                          child: Stack(
                            children: [
                              // Mock Contributors
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
                                            'https://i.pravatar.cc/150?u=${widget.drop.id * 10 + i}'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          "+${(widget.drop.id % 3) + 2} Contributors are working on this",
                          style: GoogleFonts.outfit(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 250.ms),
                    const SizedBox(height: 32),

                    // Reward Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: theme.dividerColor.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("TOTAL REWARD",
                                  style: GoogleFonts.outfit(
                                      color: theme.textTheme.bodySmall?.color
                                          ?.withOpacity(0.7),
                                      fontSize: 10,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.bolt_rounded,
                                      color: Color(0xFFD4E157), size: 28),
                                  const SizedBox(width: 8),
                                  Text("${widget.drop.rewardXp} XP",
                                      style: GoogleFonts.outfit(
                                          color:
                                              theme.textTheme.bodyLarge?.color,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          Container(
                              width: 1, height: 40, color: theme.dividerColor),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("EST. TIME",
                                  style: GoogleFonts.outfit(
                                      color: theme.textTheme.bodySmall?.color
                                          ?.withOpacity(0.7),
                                      fontSize: 10,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text("${widget.drop.timeLimitMinutes} min",
                                  style: GoogleFonts.outfit(
                                      color: theme.textTheme.bodyLarge?.color,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 300.ms).scale(),
                    const SizedBox(height: 40),

                    // Description
                    Text("MISSION BRIEF",
                        style: GoogleFonts.outfit(
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.8),
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
                              .withOpacity(0.5), // Subtle code bg
                          fontSize: 14,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Serious Warning Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2B0E0E)
                            : Colors.red[50], // Light Red bg in Light Mode
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: isDark
                                ? Colors.redAccent.withOpacity(0.3)
                                : Colors.redAccent.withOpacity(0.2)),
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
                              color: isDark
                                  ? Colors.white70
                                  : Colors
                                      .red[900], // Dark Red text in Light Mode
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
              child: GestureDetector(
                onTap: isEnrolled
                    ? () => context.push('/execution', extra: widget.drop)
                    : () => _showStartDialog(context),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: isEnrolled
                        ? Colors.blueAccent
                        : (isDark ? Colors.white : Colors.black),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                          color: (isEnrolled ? Colors.blueAccent : Colors.black)
                              .withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 5))
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isEnrolled ? "Continue Mission" : "Start Executing",
                        style: GoogleFonts.outfit(
                          color: isEnrolled
                              ? Colors.white
                              : (isDark ? Colors.black : Colors.white),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                            color: Colors.white),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
          ],
        ),
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
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
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
                  color: const Color(0xFF00C853).withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00C853).withOpacity(0.2),
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
                  color: Colors.white.withOpacity(0.5),
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
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
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
                  color: Colors.white.withOpacity(0.6),
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
                            color: Colors.white.withOpacity(0.4),
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
                        shadowColor: const Color(0xFF00C853).withOpacity(0.5),
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
        color: _getDomainColor(domain).withOpacity(0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: _getDomainColor(domain).withOpacity(0.3)),
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
