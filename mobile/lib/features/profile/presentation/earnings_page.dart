import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            // Balance Card (Kept mostly static as it's a specific gradient design,
            // but text colors adapted for contrast if needed)
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
                      color: const Color(0xFF00C853).withOpacity(0.4),
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
                    "\$1,250.00",
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
                    "+ \$250.00 this month",
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text("WITHDRAW FUNDS",
                          style: GoogleFonts.spaceMono(
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            )
                .animate()
                .slideY(begin: 0.2, duration: 600.ms, curve: Curves.easeOut),

            const SizedBox(height: 40),

            // Analytics Section
            Text("ANALYTICS",
                style: GoogleFonts.spaceMono(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildAnalyticCard(
                      context, "Pending", "\$120", Colors.orangeAccent),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAnalyticCard(
                      context, "Projects", "12", Colors.blueAccent),
                ),
              ],
            ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: 40),

            // Transaction History
            Text("HISTORY",
                style: GoogleFonts.spaceMono(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildHistoryItem(context, "Project Alpha Payout", "+ \$450.00",
                "Today, 10:23 AM", true),
            _buildHistoryItem(context, "Bug Bounty: Critical", "+ \$500.00",
                "Jan 12, 2024", true),
            _buildHistoryItem(context, "Withdrawal to Bank", "- \$1,000.00",
                "Jan 10, 2024", false),
            _buildHistoryItem(
                context, "Micro-Correction", "+ \$50.00", "Jan 05, 2024", true),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticCard(
      BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(height: 12),
          Text(value,
              style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color)),
          Text(label,
              style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5))),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, String title, String amount,
      String date, bool isIncoming) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isIncoming
                      ? const Color(0xFF00C853).withOpacity(0.1)
                      : theme.dividerColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                    isIncoming ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isIncoming
                        ? const Color(0xFF00C853)
                        : theme.iconTheme.color?.withOpacity(0.7),
                    size: 20),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.outfit(
                          color: theme.textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.w600)),
                  Text(date,
                      style: GoogleFonts.spaceMono(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.5),
                          fontSize: 10)),
                ],
              ),
            ],
          ),
          Text(
            amount,
            style: GoogleFonts.outfit(
                color: isIncoming
                    ? const Color(0xFF00C853)
                    : theme.textTheme.bodyLarge?.color,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }
}
