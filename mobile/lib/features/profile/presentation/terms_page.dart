import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("TERMS",
            style: GoogleFonts.spaceMono(
                color: theme.textTheme.titleLarge?.color,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        centerTitle: true,
        leading: BackButton(color: theme.iconTheme.color),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildParagraph(context, "1. Introduction",
                "Welcome to DevApp. By using our application, you agree to these terms. We are committed to building a transparent platform for developers."),
            _buildParagraph(context, "2. User Accounts",
                "You are responsible for safeguarding the password that you use to access the service and for any activities or actions under your password."),
            _buildParagraph(context, "3. Content & Activity",
                "Our platform allows you to post drops, link code, and earn rewards. You retain ownership of any intellectual property rights that you hold in that content."),
            _buildParagraph(context, "4. Termination",
                "We may terminate or suspend access to our service immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms."),
            const SizedBox(height: 20),
            Center(
                child: Text("Last updated: Jan 2026",
                    style: GoogleFonts.spaceMono(
                        color: theme.textTheme.bodyMedium?.color
                            ?.withValues(alpha: 0.5)))),
          ],
        ),
      ),
    );
  }

  Widget _buildParagraph(BuildContext context, String title, String content) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.outfit(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(content,
              style: GoogleFonts.outfit(
                  color:
                      theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  fontSize: 16,
                  height: 1.6)),
        ],
      ),
    );
  }
}
