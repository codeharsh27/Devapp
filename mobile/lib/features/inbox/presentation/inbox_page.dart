import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/inbox_repository.dart';
import '../domain/conversation.dart';

class InboxPage extends ConsumerStatefulWidget {
  const InboxPage({super.key});

  @override
  ConsumerState<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends ConsumerState<InboxPage> {
  int _selectedIndex = 0;
  final List<String> _tabs = ["All", "Offers", "Gigs"];

  String? get _messageTypeFilter {
    switch (_selectedIndex) {
      case 1:
        return 'offer';
      case 2:
        return 'gig';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final conversationsAsync =
        ref.watch(conversationsListProvider(messageType: _messageTypeFilter));

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
                  color: Colors.purpleAccent.withValues(alpha: 0.08),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent.withValues(alpha: 0.15),
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
                  color: Colors.orangeAccent.withValues(alpha: 0.05),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withValues(alpha: 0.1),
                      blurRadius: 100,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.4),
              ),
            ),
          ],

          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(conversationsListProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                                        ?.withValues(alpha: 0.6),
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
                                    ? (isDark
                                        ? Colors.white
                                        : theme.primaryColor)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : (isDark
                                            ? theme.dividerColor
                                                .withValues(alpha: 0.3)
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
                      child: conversationsAsync.when(
                        data: (conversations) {
                          if (conversations.isEmpty) {
                            return _buildEmptyState(theme, isDark);
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: conversations.length,
                            itemBuilder: (context, index) {
                              return _buildMessageTile(
                                  conversations[index], theme, isDark);
                            },
                          );
                        },
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (error, stack) =>
                            _buildEmptyState(theme, isDark),
                      ),
                    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            "No messages yet",
            style: GoogleFonts.outfit(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "When recruiters or founders reach out,\ntheir messages will appear here.",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(Conversation item, ThemeData theme, bool isDark) {
    // Parse avatar color from hex string
    Color avatarColor;
    try {
      avatarColor =
          Color(int.parse(item.senderAvatarColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      avatarColor = Colors.purpleAccent;
    }

    // Get badge info based on message type
    String? badgeLabel;
    Color? badgeColor;
    if (item.messageType == 'offer') {
      badgeLabel = "OFFER";
      badgeColor = const Color(0xFF00C853);
    } else if (item.messageType == 'gig') {
      badgeLabel = "GIG TASK";
      badgeColor = Colors.orangeAccent;
    }

    return Dismissible(
      key: Key('conversation_${item.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Delete Conversation", style: GoogleFonts.outfit()),
            content: Text(
              "Are you sure you want to delete this conversation? This action cannot be undone.",
              style: GoogleFonts.outfit(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("Cancel", style: GoogleFonts.outfit()),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Delete",
                    style: GoogleFonts.outfit(color: Colors.redAccent)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        final messenger = ScaffoldMessenger.of(context);
        try {
          await ref
              .read(inboxRepositoryProvider.notifier)
              .deleteConversation(item.id);
          messenger.showSnackBar(
            SnackBar(
                content:
                    Text("Conversation deleted", style: GoogleFonts.outfit())),
          );
          ref.invalidate(conversationsListProvider);
        } catch (e) {
          messenger.showSnackBar(
            SnackBar(
              content: Text("Failed to delete", style: GoogleFonts.outfit()),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          context.push('/chat/${item.id}');
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? theme.dividerColor.withValues(alpha: 0.05)
                  : Colors.grey.withValues(alpha: 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: avatarColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    item.senderName[0],
                    style: GoogleFonts.outfit(
                      color: avatarColor,
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
                          child: Row(
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
                              if (badgeLabel != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: badgeColor?.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    badgeLabel,
                                    style: GoogleFonts.spaceMono(
                                      color: badgeColor,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Text(
                          _formatTime(item.lastMessageTime ?? item.createdAt),
                          style: GoogleFonts.outfit(
                            color: theme.textTheme.bodySmall?.color
                                ?.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    if (item.senderRole != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.senderRole!,
                        style: GoogleFonts.outfit(
                          color: theme.primaryColor.withValues(alpha: 0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      item.lastMessage ?? "No messages yet",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        color: theme.textTheme.bodyMedium?.color
                            ?.withValues(alpha: 0.7),
                        fontSize: 14,
                        height: 1.4,
                        fontWeight:
                            !item.isRead ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (!item.isRead || item.unreadCount > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 20),
                  child: Container(
                    padding: item.unreadCount > 0
                        ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
                        : null,
                    width: item.unreadCount > 0 ? null : 8,
                    height: item.unreadCount > 0 ? null : 8,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: item.unreadCount > 0
                          ? BorderRadius.circular(10)
                          : null,
                      shape: item.unreadCount > 0
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                    ),
                    child: item.unreadCount > 0
                        ? Text(
                            '${item.unreadCount}',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[time.weekday - 1];
    } else {
      return '${time.day}/${time.month}';
    }
  }
}
