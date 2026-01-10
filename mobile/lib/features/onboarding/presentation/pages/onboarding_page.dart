import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    if (mounted) {
      context.go('/login');
    }
  }

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: "SECURE THE BAG",
      subtitle: "ACCESS MISSIONS",
      description:
          "Infiltrate high-value targets. Execute active drops to earn XP and Paid rewards.",
      icon: Icons.lock_open_rounded,
    ),
    OnboardingContent(
      title: "EXECUTE PROTOCOLS",
      subtitle: "COMPLETE TASKS",
      description:
          "Precision is key. Complete frontend, backend, and AI optimization tasks within the time limit.",
      icon: Icons.code_rounded,
    ),
    OnboardingContent(
      title: "LEVEL UP STATUS",
      subtitle: "CLAIM REWARDS",
      description:
          "Rise through the ranks from Initiate to Elite Operative. Your skills determine your payout.",
      icon: Icons.stars_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Force dark theme aesthetic for onboarding
    const backgroundColor = Color(0xFF121212);
    const primaryColor = Color(0xFF00C853);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // 1. Dynamic Background (Orbs)
          Positioned(
            top: -100,
            right: -100,
            child: _buildOrb(Colors.blueAccent),
          ),
          Positioned(
            bottom: 100,
            left: -50,
            child: _buildOrb(primaryColor),
          ),

          // 2. Glass Overlay/Noise
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),

          // 3. Scanlines/Grid Effect (Optional, simulated with simple divider lines)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      Colors.transparent
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // 4. Content
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SYSTEM_INIT",
                        style: GoogleFonts.spaceMono(
                          color: Colors.white54,
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                      ),
                      if (_currentPage < _contents.length - 1)
                        TextButton(
                          onPressed: _completeOnboarding,
                          child: Text(
                            "SKIP_INTRO",
                            style: GoogleFonts.spaceMono(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemCount: _contents.length,
                    itemBuilder: (context, index) {
                      return _buildPage(_contents[index]);
                    },
                  ),
                ),

                // Bottom Controls
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page Indicators
                      Row(
                        children: List.generate(
                          _contents.length,
                          (index) => AnimatedContainer(
                            duration: 300.ms,
                            margin: const EdgeInsets.only(right: 8),
                            width: _currentPage == index ? 24 : 8,
                            height: 4,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? primaryColor
                                  : Colors.white24,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),

                      // Next/Start Button
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage == _contents.length - 1) {
                            _completeOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: 500.ms,
                              curve: Curves.easeOutExpo,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _currentPage == _contents.length - 1
                                  ? "ACCESS SYSTEM"
                                  : "NEXT STEP",
                              style: GoogleFonts.spaceMono(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                      ).animate().scale(delay: 200.ms, duration: 300.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrb(Color color) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 100,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingContent content) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Icon(
              content.icon,
              size: 64,
              color: const Color(0xFF00C853),
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 48),
          Text(
            content.subtitle,
            style: GoogleFonts.spaceMono(
              color: const Color(0xFF00C853),
              fontSize: 14,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 200.ms).slideX(),
          const SizedBox(height: 16),
          Text(
            content.title,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 48,
              height: 1.0,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 300.ms).moveY(begin: 20),
          const SizedBox(height: 24),
          Text(
            content.description,
            style: GoogleFonts.outfit(
              color: Colors.white70,
              fontSize: 18,
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 400.ms).moveY(begin: 20),
        ],
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;

  OnboardingContent({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
  });
}
