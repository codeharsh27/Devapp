import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Placeholder / Construction State
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("MONETIZATION",
            style: GoogleFonts.spaceMono(
                color: theme.textTheme.titleLarge?.color,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        leading: BackButton(color: theme.iconTheme.color),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00C853),
                      Color(0xFF69F0AE)
                    ], // Cyber Green
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00C853).withValues(alpha: 0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    )
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "TOTAL EARNINGS",
                        style: GoogleFonts.spaceMono(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.currency_exchange,
                            color: Colors.black87, size: 20),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "0 Rs",
                    style: GoogleFonts.outfit(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      height: 1.0,
                    ),
                  )
                      .animate()
                      .scale(duration: 500.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 8),
                  Text(
                    "Start completing tasks!",
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: null, // Disabled
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        disabledBackgroundColor: Colors.black38,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text("WITHDRAW FUNDS",
                          style: GoogleFonts.spaceMono(
                              fontWeight: FontWeight.bold,
                              color: Colors.white54)),
                    ),
                  )
                ],
              ),
            )
                .animate()
                .slideY(begin: 0.2, duration: 600.ms, curve: Curves.easeOut),

            const SizedBox(height: 60),

            // Construction / Warning Message
            Center(
              child: Column(
                children: [
                  Icon(Icons.construction_rounded,
                      size: 64,
                      color: theme.textTheme.bodyMedium?.color
                          ?.withValues(alpha: 0.2)),
                  const SizedBox(height: 24),
                  Text(
                    "PAGE UNDER CONSTRUCTION",
                    style: GoogleFonts.spaceMono(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "This section is currently being built.\nPlease complete tasks to unlock earnings.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: theme.textTheme.bodyMedium?.color
                          ?.withValues(alpha: 0.6),
                      height: 1.5,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
            ),
          ],
        ),
      ),
    );
  }
}
