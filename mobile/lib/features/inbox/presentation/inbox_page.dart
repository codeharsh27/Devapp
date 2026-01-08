import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_animate/flutter_animate.dart';

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
      badgeColor: const Color(0xFF00E676),
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
      badgeColor: const Color(0xFF00E676),
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
      body: SafeArea(
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
                          "Inbox",
                          style: GoogleFonts.outfit(
                            color: theme.textTheme.titleLarge?.color,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Opportunities & Requests",
                          style: GoogleFonts.outfit(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    _buildProfileAvatar(theme),
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? Colors.white : theme.primaryColor)
                              : (isDark ? theme.cardColor : Colors.grey[200]),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: isSelected
                                  ? (isDark ? Colors.white : theme.primaryColor)
                                  : (isDark
                                      ? theme.dividerColor
                                      : Colors.grey[400]!)),
                        ),
                        child: Text(
                          _tabs[index],
                          style: GoogleFonts.outfit(
                            color: isSelected
                                ? (isDark ? Colors.black : Colors.white)
                                : (isDark
                                    ? theme.textTheme.bodyMedium?.color
                                    : Colors.black87),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 24),

              // Message List
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161616) : theme.cardColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      )
                    ]),
                child: ListView.separated(
                  padding: const EdgeInsets.all(24),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredMessages.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: theme.dividerColor, height: 32),
                  itemBuilder: (context, index) {
                    return _buildMessageTile(filteredMessages[index], theme);
                  },
                ),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageTile(_MessageItem item, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        context.push('/chat', extra: {
          'senderName': item.senderName,
          'senderRole': item.senderRole,
          'avatarColor': item.avatarColor,
        });
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [item.avatarColor, item.avatarColor.withOpacity(0.5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  item.senderName[0],
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.senderName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            color: theme.textTheme.titleLarge?.color,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        item.time,
                        style: GoogleFonts.outfit(
                          color: item.isUnread
                              ? Colors.blueAccent
                              : theme.textTheme.bodySmall?.color,
                          fontSize: 12,
                          fontWeight: item.isUnread
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    item.senderRole,
                    style: GoogleFonts.outfit(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color: item.isUnread
                          ? theme.textTheme.bodyLarge?.color
                          : theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.4,
                      fontWeight:
                          item.isUnread ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  if (item.hasBadge) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.badgeColor!.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.badgeLabel!,
                        style: GoogleFonts.outfit(
                          color: item.badgeColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(ThemeData theme) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: theme.cardColor,
        shape: BoxShape.circle,
        border: Border.all(color: theme.dividerColor),
        image: const DecorationImage(
          image: AssetImage('assets/profile_pic.jpg'), // Fallback
          fit: BoxFit.cover,
        ),
      ),
      child: const Icon(Icons.person, color: Colors.grey),
    );
  }
}

class _MessageItem {
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
