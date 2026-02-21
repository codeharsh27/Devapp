import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/dio_provider.dart';

class SelectClassPage extends ConsumerStatefulWidget {
  const SelectClassPage({super.key});

  @override
  ConsumerState<SelectClassPage> createState() => _SelectClassPageState();
}

class _SelectClassPageState extends ConsumerState<SelectClassPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _particleController;
  int _currentPage = 0;
  bool _isSubmitting = false;
  final List<Particle> _particles = List.generate(60, (index) => Particle());

  final List<ClassOption> _classes = [
    ClassOption(
      id: 'backend',
      title: 'SYSTEM ARCHITECT',
      subtitle: 'BACKEND & INFRASTRUCTURE',
      icon: Icons.dns_rounded,
      color: const Color(0xFF00FF94), // Bright Mint
      description:
          "You are the backbone of the digital world. You construct the logic, manage the data, and ensure the system never falters.",
      stats: {'Logic': 95, 'Scale': 90, 'Security': 85},
    ),
    ClassOption(
      id: 'frontend',
      title: 'INTERFACE DESIGNER',
      subtitle: 'FRONTEND & UI/UX',
      icon: Icons.palette_rounded,
      color: const Color(0xFF00E0FF), // Cyan Neon
      description:
          "You bridge the gap between man and machine. Your code brings beauty, fluidity, and intuitive interaction to life.",
      stats: {'Visual': 95, 'Motion': 90, 'Empathy': 85},
    ),
    ClassOption(
      id: 'mobile',
      title: 'MOBILE OPERATIVE',
      subtitle: 'IOS & ANDROID',
      icon: Icons.smartphone_rounded,
      color: const Color(0xFFFFB800), // Solar Yellow
      description:
          "You build the world in their pocket. Performance, touch, and accessibility are your weapons of choice.",
      stats: {'Touch': 95, 'Native': 90, 'Reach': 90},
    ),
    ClassOption(
      id: 'ai',
      title: 'AI RESEARCHER',
      subtitle: 'ML & INTELLIGENCE',
      icon: Icons.psychology_rounded,
      color: const Color(0xFFAA00FF), // Deep Violet
      description:
          "You teach machines to think. You parse the chaos of data to find meaning, prediction, and synthetic evolution.",
      stats: {'Data': 95, 'Math': 90, 'Future': 95},
    ),
    ClassOption(
      id: 'product',
      title: 'PRODUCT STRATEGIST',
      subtitle: 'VISION & LEADERSHIP',
      icon: Icons.explore_rounded,
      color: const Color(0xFFFF3D00), // Mars Red
      description:
          "You navigate the unknown. You define the 'Why' and the 'How', rallying the team towards a singular vision.",
      stats: {'Vision': 95, 'Lead': 90, 'Impact': 90},
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.75, initialPage: 0);
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  Future<void> _confirmSelection() async {
    HapticFeedback.mediumImpact();
    setState(() => _isSubmitting = true);

    try {
      final selectedClass = _classes[_currentPage];
      final dio = ref.read(dioProvider);

      // Guest Logic check (using Supabase directly to be safe, or just check dio header/auth provider)
      // Since we are inside ConsumerState, we can check auth provider
      // But simple way:
      final prefs = await SharedPreferences.getInstance();

      // We assume if we are on this page and redirects allow it, we might be guest.
      // Let's rely on success/fail of API or explicit check.
      // Actually, router logic now allows guests here.

      // Store locally regardless (as backup or for guest)
      await prefs.setString('temp_selected_class_id', selectedClass.id);
      await prefs.setBool('has_selected_class', true); // Optimistic

      bool isLoggedIn = false;
      try {
        // Try to send to backend if we have a token
        // If this fails with 401, we know we are guest
        await dio.post('/users/me/class', data: {
          'domain': selectedClass.id,
        });
        isLoggedIn = true;
      } catch (e) {
        // Likely 401 Unauthorized => Guest
        isLoggedIn = false;
      }

      if (mounted) {
        if (isLoggedIn) {
          context.go('/home');
        } else {
          // Guest -> Go to Signup to create account and claim this class
          context.go('/signup');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeClass = _classes[_currentPage];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Particle Starfield Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(
                    color: activeClass.color,
                    animationValue: _particleController.value,
                    particles: _particles,
                  ),
                );
              },
            ),
          ),

          // 2. Ambient Gradient Vignette
          AnimatedContainer(
            duration: 1200.ms,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  activeClass.color.withValues(alpha: 0.05),
                  Colors.black.withValues(alpha: 0.8),
                  Colors.black,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),

          // 3. Grid Overlay (Scanline effect)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.1),
                    ],
                    stops: const [0.5, 0.5],
                    tileMode: TileMode.repeated,
                  ),
                ),
                child: Opacity(
                  opacity: 0.03, // Very subtle scanlines
                  child: Image.network(
                    "https://www.transparenttextures.com/patterns/diagmonds-light.png",
                    repeat: ImageRepeat.repeat,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                ),
              ),
            ),
          ),

          // 3.5 Navigation Hints (Arrows)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Arrow
                  AnimatedOpacity(
                    duration: 300.ms,
                    opacity: _currentPage > 0 ? 1.0 : 0.0,
                    child: IconButton(
                      onPressed: _currentPage > 0
                          ? () => _pageController.previousPage(
                              duration: 500.ms, curve: Curves.easeOutCubic)
                          : null,
                      icon: Icon(Icons.chevron_left,
                          color: Colors.white.withValues(alpha: 0.5), size: 32),
                    ),
                  ),
                  // Right Arrow
                  AnimatedOpacity(
                    duration: 300.ms,
                    opacity: _currentPage < _classes.length - 1 ? 1.0 : 0.0,
                    child: IconButton(
                      onPressed: _currentPage < _classes.length - 1
                          ? () => _pageController.nextPage(
                              duration: 500.ms, curve: Curves.easeOutCubic)
                          : null,
                      icon: Icon(Icons.chevron_right,
                          color: Colors.white.withValues(alpha: 0.5), size: 32),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Main Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.only(top: 32.0, bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        "IDENTITY PROTOCOL",
                        style: GoogleFonts.spaceMono(
                          color: activeClass.color,
                          fontSize: 10,
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "SELECT CLASS",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                // Carousel
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      HapticFeedback.selectionClick();
                      setState(() => _currentPage = index);
                    },
                    itemCount: _classes.length,
                    itemBuilder: (context, index) {
                      final item = _classes[index];
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double pageOffset = 0.0;
                          if (_pageController.position.haveDimensions) {
                            pageOffset = _pageController.page! - index;
                          } else {
                            pageOffset = (index - _currentPage).toDouble();
                          }

                          final scale =
                              (1 - (pageOffset.abs() * 0.2)).clamp(0.8, 1.0);
                          final opacity =
                              (1 - (pageOffset.abs() * 0.6)).clamp(0.3, 1.0);
                          final isActive = index == _currentPage;

                          return Center(
                            child: Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001) // Perspective
                                ..rotateY(
                                    0.15 * pageOffset), // Reduced rotation
                              alignment: Alignment.center,
                              child: Transform.scale(
                                scale: Curves.easeOutBack.transform(scale),
                                child: Opacity(
                                  opacity: opacity,
                                  child: _buildUltimateCard(item, isActive),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // 5. Bottom Controls / Stats (Fixed height to preserve Card aspect ratio)
                SizedBox(
                  height: 240,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Stats Indicators
                        Row(
                          children: activeClass.stats.entries.map((e) {
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.key.toUpperCase(),
                                      style: GoogleFonts.spaceMono(
                                        color: Colors.white38,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: e.value / 100,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: activeClass.color,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: activeClass.color
                                                    .withValues(alpha: 0.5),
                                                blurRadius: 6,
                                                spreadRadius: 1,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                          .animate(
                                              key: ValueKey(
                                                  activeClass.id + e.key))
                                          .slideX(
                                              begin: -1,
                                              duration: 600.ms,
                                              curve: Curves.easeOutExpo),
                                    ),
                                    const SizedBox(height: 4),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "${e.value}%",
                                        style: GoogleFonts.jetBrainsMono(
                                          color: activeClass.color,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const Spacer(),

                        // Primary Action Button
                        AnimatedContainer(
                          duration: 400.ms,
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: activeClass.color.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _confirmSelection,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: activeClass.color,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.black))
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "INITIALIZE SYSTEM",
                                        style: GoogleFonts.spaceMono(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1,
                                        ),
                                      )
                                          .animate(
                                              onPlay: (c) =>
                                                  c.repeat(period: 5.seconds))
                                          .shimmer(
                                              duration: 1200.ms,
                                              color: Colors.white,
                                              size: 0.2), // Tech Shimmer
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward, size: 20),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUltimateCard(ClassOption item, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isActive ? item.color.withValues(alpha: 0.6) : Colors.white10,
          width: isActive ? 1.5 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: item.color.withValues(alpha: 0.15),
                  blurRadius: 40,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.8),
                  blurRadius: 20,
                  spreadRadius: -5,
                  offset: const Offset(0, 10),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Internal Gradient / Glass
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      item.color.withValues(alpha: 0.08),
                      Colors.transparent,
                      Colors.transparent,
                      item.color.withValues(alpha: 0.05),
                    ],
                    stops: const [0.0, 0.4, 0.6, 1.0],
                  ),
                ),
              ),
            ),

            // Tech Deco Lines
            Positioned(
              top: 20,
              right: 20,
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                        color: item.color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.5),
                        shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 60,
                    height: 2,
                    color: item.color.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Floating Icon
                      AnimatedScale(
                        duration: 400.ms,
                        scale: isActive ? 1.0 : 0.8,
                        curve: Curves.easeOutBack,
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                              border: Border.all(
                                  color: item.color.withValues(alpha: 0.3),
                                  width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: item.color.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                )
                              ]),
                          child: Icon(item.icon, size: 52, color: item.color),
                        ),
                      ),

                      const SizedBox(height: 32),

                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.subtitle,
                          style: GoogleFonts.spaceMono(
                            color: item.color,
                            fontSize: 10,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        item.description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          color: Colors.white60,
                          fontSize: 15,
                          height: 1.5,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Particle System
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Advanced Particle System (Constellation)
// ---------------------------------------------------------------------------

class ParticlePainter extends CustomPainter {
  final Color color;
  final double animationValue;
  final List<Particle> _particles;

  ParticlePainter({
    required this.color,
    required this.animationValue,
    required List<Particle> particles,
  }) : _particles = particles;

  @override
  void paint(Canvas canvas, Size size) {
    final paintNode = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final paintLine = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Update and Draw Nodes
    for (var i = 0; i < _particles.length; i++) {
      var p = _particles[i];
      p.update(size, animationValue);

      canvas.drawCircle(Offset(p.x, p.y), p.size, paintNode);

      // Draw Connections (Constellation Effect)
      // Only connect to upcoming particles to avoid double drawing
      for (var j = i + 1; j < _particles.length; j++) {
        var p2 = _particles[j];
        final dx = p.x - p2.x;
        final dy = p.y - p2.y;
        final dist = dx * dx + dy * dy;

        // Connection Threshold (squared distance)
        if (dist < 10000) {
          // ~100 pixels
          canvas.drawLine(Offset(p.x, p.y), Offset(p2.x, p2.y), paintLine);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.color != color;
  }
}

class Particle {
  late double x;
  late double y;
  late double size;
  late double speed;
  double phaseOffset; // For sine wave movement

  Particle() : phaseOffset = math.Random().nextDouble() * 2 * math.pi {
    _reset();
    y = math.Random().nextDouble() * 1000;
  }

  void _reset() {
    x = math.Random().nextDouble() * 500;
    y = 1000;
    size = math.Random().nextDouble() * 2.5 + 1;
    speed = math.Random().nextDouble() * 1.5 + 0.5;
  }

  void update(Size canvasSize, double time) {
    if (x == 0 && y == 1000) {
      // First run init to canvas size
      x = math.Random().nextDouble() * canvasSize.width;
      y = math.Random().nextDouble() * canvasSize.height;
    }

    y -= speed;
    x += math.sin(y * 0.01 + phaseOffset) * 0.5; // Gentle drift

    if (y < -10) {
      y = canvasSize.height + 10;
      x = math.Random().nextDouble() * canvasSize.width;
    }
    if (x < -10) x = canvasSize.width + 10;
    if (x > canvasSize.width + 10) x = -10;
  }
}

class ClassOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String description;
  final Map<String, int> stats;

  ClassOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.description,
    required this.stats,
  });
}
