import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui'; // For BackdropFilter

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  int _selectedIndex = 0;
  final List<String> _tabs = ["All", "Offers", "Gigs"];

  // Mock Data
  final List<_MessageItem> _allMessages = [
    _MessageItem(
      senderName: "Sarah Chen",
      senderRole: "Founder @ NexusAI",
      message:
          "Saw your submission for the 'Vector Database' task. The optimization logic was brilliant. Would you be open to a quick chat about a Lead role?",
      time: "10:30 AM",
      avatarColor: Colors.purpleAccent,
      hasBadge: true,
      badgeLabel: "OFFER",
      badgeColor: const Color(0xFF00C853),
      isUnread: true,
      type: "Offer",
    ),
    _MessageItem(
      senderName: "Michael Ross",
      senderRole: "Talent Acquisition @ Stripe",
      message:
          "Hi! We are looking for backend engineers with your skill set. Your recent activity caught our eye.",
      time: "Yesterday",
      avatarColor: Colors.blueAccent,
      hasBadge: true,
      badgeLabel: "GIG TASK",
      badgeColor: Colors.orangeAccent,
      isUnread: false,
      type: "Gig",
    ),
    _MessageItem(
      senderName: "David Kim",
      senderRole: "CTO @ Flux",
      message:
          "I have a short-term contract (Gig) available strictly for Python optimization.",
      time: "Mon",
      avatarColor: Colors.tealAccent,
      hasBadge: true,
      badgeLabel: "GIG TASK",
      badgeColor: Colors.orangeAccent,
      isUnread: false,
      type: "Gig",
    ),
    _MessageItem(
      senderName: "Airbnb Careers",
      senderRole: "Recruiting Team",
      message:
          "We have reviewed your profile and would like to extend a Job Offer.",
      time: "Sat",
      avatarColor: Colors.redAccent,
      hasBadge: true,
      badgeLabel: "OFFER",
      badgeColor: const Color(0xFF00C853),
      isUnread: false,
      type: "Offer",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Filter Logic
    List<_MessageItem> filteredMessages = _allMessages;
    if (_selectedIndex == 1) {
      filteredMessages = _allMessages.where((m) => m.type == "Offer").toList();
    } else if (_selectedIndex == 2) {
      filteredMessages = _allMessages.where((m) => m.type == "Gig").toList();
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Dynamic Background
          if (isDark) ...[
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purpleAccent.withOpacity(0.08),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent.withOpacity(0.15),
                      blurRadius: 120,
                      spreadRadius: 60,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 150,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orangeAccent.withOpacity(0.05),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.1),
                      blurRadius: 100,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
            // 3. Light Overlay for contrast
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ],

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Custom Header
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "COMMUNICATIONS",
                              style: GoogleFonts.spaceMono(
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.6),
                                  fontSize: 10,
                                  letterSpacing: 3,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "INBOX LINK",
                              style: GoogleFonts.outfit(
                                  color: theme.textTheme.titleLarge?.color,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2),

                  // Filter Tabs
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      itemCount: _tabs.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final isSelected = _selectedIndex == index;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: AnimatedContainer(
                            duration: 200.ms,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark ? Colors.white : theme.primaryColor)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : (isDark
                                          ? theme.dividerColor.withOpacity(0.3)
                                          : Colors.grey[400]!)),
                            ),
                            child: Text(
                              _tabs[index].toUpperCase(),
                              style: GoogleFonts.spaceMono(
                                  color: isSelected
                                      ? (isDark ? Colors.black : Colors.white)
                                      : (isDark
                                          ? theme.textTheme.bodyMedium?.color
                                          : Colors.black87),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                          ),
                        );
                      },
                    ),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 24),

                  // Message List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredMessages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageTile(
                            filteredMessages[index], theme, isDark);
                      },
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(_MessageItem item, ThemeData theme, bool isDark) {
    return GestureDetector(
      onTap: () {
        context.push('/chat', extra: {
          'senderName': item.senderName,
          'senderRole': item.senderRole,
          'avatarColor': item.avatarColor,
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? theme.dividerColor.withOpacity(0.05)
                : Colors.grey.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simple Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: item.avatarColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  item.senderName[0],
                  style: GoogleFonts.outfit(
                    color: item.avatarColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          item.senderName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            color: theme.textTheme.titleLarge?.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        item.time,
                        style: GoogleFonts.outfit(
                          color: theme.textTheme.bodySmall?.color
                              ?.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.senderRole,
                    style: GoogleFonts.outfit(
                      color: theme.primaryColor.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.4,
                      fontWeight:
                          item.isUnread ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            if (item.isUnread)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 20),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} // Properly closing the class here

class _MessageItem {
  // Re-declaring this helper class outside
  final String senderName;
  final String senderRole;
  final String message;
  final String time;
  final Color avatarColor;
  final bool hasBadge;
  final String? badgeLabel;
  final Color? badgeColor;
  final bool isUnread;
  final String type;

  _MessageItem({
    required this.senderName,
    required this.senderRole,
    required this.message,
    required this.time,
    required this.avatarColor,
    required this.hasBadge,
    this.badgeLabel,
    this.badgeColor,
    required this.isUnread,
    required this.type,
  });
}
