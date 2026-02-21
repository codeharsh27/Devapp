import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Gradient Elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor.withValues(alpha: 0.1),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    blurRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withValues(alpha: 0.1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withValues(alpha: 0.1),
                    blurRadius: 100,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: theme.iconTheme.color),
                        onPressed: () => context.pop(),
                      ),
                      const Spacer(),
                      Text(
                        "MEMBERSHIP",
                        style: GoogleFonts.spaceMono(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: theme.textTheme.bodyMedium?.color
                              ?.withValues(alpha: 0.5),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // Balance for back button
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // The Founder Card
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 400),
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1A1A1A), Color(0xFF2C3E50)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 1),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.auto_awesome,
                                      color: Color(0xFFFFD700), size: 32),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "LIFETIME ACCESS",
                                      style: GoogleFonts.spaceMono(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              Text(
                                "FOUNDER",
                                style: GoogleFonts.outfit(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                              Text(
                                "EARLY SUPPORTER",
                                style: GoogleFonts.spaceMono(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.6),
                                  letterSpacing: 4,
                                ),
                              ),
                              const SizedBox(height: 40),
                              Row(
                                children: [
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("\$0.00",
                                          style: GoogleFonts.outfit(
                                              color: const Color(0xFFFFD700),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24)),
                                      Text("/ forever",
                                          style: GoogleFonts.outfit(
                                              color: Colors.white
                                                  .withValues(alpha: 0.5),
                                              fontSize: 12)),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                            .animate()
                            .flip(duration: 600.ms, curve: Curves.easeOutBack),

                        const SizedBox(height: 48),

                        // Message
                        Text(
                          "Thank You.",
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.titleLarge?.color,
                          ),
                        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

                        const SizedBox(height: 16),
                        Text(
                          "As one of our first users, you're not just a customer—you're a partner. We've unlocked every premium feature for your account, permanently.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withValues(alpha: 0.7),
                            height: 1.6,
                          ),
                        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

                        const SizedBox(height: 40),

                        // Features Grid
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildFeatureTag(theme, "Unlimited XP"),
                            _buildFeatureTag(theme, "Priority Access"),
                            _buildFeatureTag(theme, "No Commission"),
                            _buildFeatureTag(theme, "Dev Chats"),
                            _buildFeatureTag(theme, "Insider Updates"),
                          ],
                        ).animate().fadeIn(delay: 500.ms),
                      ],
                    ),
                  ),
                ),

                // Bottom Action
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Claim Benefits",
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ).animate().slideY(begin: 1.0, duration: 500.ms, delay: 600.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTag(ThemeData theme, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: theme.textTheme.bodyMedium?.color,
        ),
      ),
    );
  }
}
