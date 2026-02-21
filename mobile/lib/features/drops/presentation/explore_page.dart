import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ExplorePage extends ConsumerWidget {
  const ExplorePage({super.key});

  final List<DomainCardData> _domains = const [
    DomainCardData(
      id: 'backend',
      title: 'BACKEND',
      subtitle: 'SYSTEMS',
      icon: Icons.dns_rounded,
      color: Color(0xFF00FF94),
      description: "Architecture & DB",
      gridCrossAxisCount: 2,
      gridMainAxisCount: 2,
    ),
    DomainCardData(
      id: 'frontend',
      title: 'FRONTEND',
      subtitle: 'INTERFACES',
      icon: Icons.palette_rounded,
      color: Color(0xFF00E0FF),
      description: "UI/UX & Animation",
      gridCrossAxisCount: 2,
      gridMainAxisCount: 2,
    ),
    DomainCardData(
      id: 'ai',
      title: 'AI CORE',
      subtitle: 'INTELLIGENCE',
      icon: Icons.psychology_rounded,
      color: Color(0xFFAA00FF),
      description: "ML Models & Data",
      gridCrossAxisCount: 4, // Full width
      gridMainAxisCount: 2,
    ),
    DomainCardData(
      id: 'mobile',
      title: 'MOBILE',
      subtitle: 'NATIVE',
      icon: Icons.smartphone_rounded,
      color: Color(0xFFFFB800),
      description: "iOS & Android",
      gridCrossAxisCount: 2,
      gridMainAxisCount: 2,
    ),
    DomainCardData(
      id: 'cloud',
      title: 'CLOUD',
      subtitle: 'DEVOPS',
      icon: Icons.cloud_upload_rounded,
      color: Color(0xFF2979FF),
      description: "Infra & Scaling",
      gridCrossAxisCount: 2,
      gridMainAxisCount: 2,
    ),
    DomainCardData(
      id: 'design',
      title: 'DESIGN',
      subtitle: 'CREATIVE',
      icon: Icons.brush_rounded,
      color: Color(0xFFFF3D00),
      description: "Product & Flow",
      gridCrossAxisCount: 4, // Full width
      gridMainAxisCount: 2,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.go('/home'),
        ),
        title: Text(
          "SECTOR MAP",
          style: GoogleFonts.spaceMono(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Subtle Cyber Grid Background
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 120),
              child: StaggeredGrid.count(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: _domains.map((domain) {
                  return StaggeredGridTile.count(
                    crossAxisCellCount: domain.gridCrossAxisCount,
                    mainAxisCellCount: domain.gridMainAxisCount,
                    child: BentoDomainCard(domain: domain)
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .scale(begin: const Offset(0.9, 0.9)),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BentoDomainCard extends StatefulWidget {
  final DomainCardData domain;

  const BentoDomainCard({super.key, required this.domain});

  @override
  State<BentoDomainCard> createState() => _BentoDomainCardState();
}

class _BentoDomainCardState extends State<BentoDomainCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      onTap: () {
        context.push('/domain-feed', extra: widget.domain.id);
      },
      child: AnimatedContainer(
        duration: 200.ms,
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered
                ? widget.domain.color.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.08),
            width: _isHovered ? 1.5 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.domain.color.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Decorative Gradient Blob
              Positioned(
                right: -40,
                bottom: -40,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.domain.color.withValues(alpha: 0.1),
                    boxShadow: [
                      BoxShadow(
                        color: widget.domain.color.withValues(alpha: 0.15),
                        blurRadius: 60,
                        spreadRadius: 20,
                      )
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top: Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            widget.domain.icon,
                            color: widget.domain.color,
                            size: 24,
                          ),
                        ),
                        if (_isHovered)
                          Icon(
                            Icons.arrow_outward_rounded,
                            color: widget.domain.color,
                            size: 20,
                          ).animate().fadeIn(),
                      ],
                    ),

                    // Bottom: Text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.domain.subtitle,
                          style: GoogleFonts.spaceMono(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 10,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.domain.title,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.domain.description, // Short description
                          style: GoogleFonts.outfit(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;

    const spacing = 40.0;

    for (var i = 0.0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (var i = 0.0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DomainCardData {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String description;
  final int gridCrossAxisCount;
  final int gridMainAxisCount;

  const DomainCardData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.description,
    this.gridCrossAxisCount = 2,
    this.gridMainAxisCount = 2,
  });
}
