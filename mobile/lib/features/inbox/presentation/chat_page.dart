import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/inbox_repository.dart';
import '../domain/conversation.dart';

class ChatPage extends ConsumerStatefulWidget {
  final int conversationId;

  const ChatPage({
    super.key,
    required this.conversationId,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_msgController.text.trim().isEmpty || _isSending) return;

    final content = _msgController.text.trim();
    _msgController.clear();

    setState(() => _isSending = true);

    try {
      await ref.read(inboxRepositoryProvider.notifier).sendMessage(
            conversationId: widget.conversationId,
            content: content,
          );

      // Refresh the conversation
      ref.invalidate(conversationDetailProvider(widget.conversationId));

      // Scroll to bottom
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Failed to send message", style: GoogleFonts.outfit()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      // Put the message back
      _msgController.text = content;
    } finally {
      setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickAndSendAttachment() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() => _isSending = true);

      try {
        // In production, upload to cloud storage and get URL
        // For now, we'll send a placeholder message
        await ref.read(inboxRepositoryProvider.notifier).sendMessage(
              conversationId: widget.conversationId,
              content: "📎 Attached: ${image.name}",
              attachmentType: "image",
            );

        ref.invalidate(conversationDetailProvider(widget.conversationId));
        _scrollToBottom();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to send attachment",
                  style: GoogleFonts.outfit()),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final conversationAsync =
        ref.watch(conversationDetailProvider(widget.conversationId));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: conversationAsync.when(
        data: (conv) => _buildAppBar(context, theme, conv),
        loading: () => AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: theme.iconTheme.color, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        error: (_, __) => AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: theme.iconTheme.color, size: 20),
            onPressed: () => context.pop(),
          ),
          title: Text("Error loading chat", style: GoogleFonts.outfit()),
        ),
      ),
      body: conversationAsync.when(
        data: (conv) => _buildChatBody(context, theme, isDark, conv),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text("Failed to load conversation", style: GoogleFonts.outfit()),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(
                    conversationDetailProvider(widget.conversationId)),
                child: Text("Retry", style: GoogleFonts.outfit()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, ThemeData theme, ConversationDetail conv) {
    Color avatarColor;
    try {
      avatarColor =
          Color(int.parse(conv.senderAvatarColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      avatarColor = Colors.purpleAccent;
    }

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            color: theme.iconTheme.color, size: 20),
        onPressed: () => context.pop(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: avatarColor,
            radius: 16,
            child: Text(conv.senderName[0],
                style: GoogleFonts.outfit(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(conv.senderName,
                    style: GoogleFonts.outfit(
                        color: theme.textTheme.titleLarge?.color,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                if (conv.senderRole != null)
                  Text(conv.senderRole!,
                      style: GoogleFonts.outfit(
                          color: theme.textTheme.bodySmall?.color,
                          fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, color: theme.iconTheme.color),
          onSelected: (value) async {
            if (value == 'delete') {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title:
                      Text("Delete Conversation", style: GoogleFonts.outfit()),
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

              if (confirm == true) {
                try {
                  await ref
                      .read(inboxRepositoryProvider.notifier)
                      .deleteConversation(widget.conversationId);
                  if (context.mounted) {
                    ref.invalidate(conversationsListProvider);
                    context.pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to delete",
                            style: GoogleFonts.outfit()),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                }
              }
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline,
                      color: Colors.redAccent, size: 20),
                  const SizedBox(width: 8),
                  Text("Delete Chat",
                      style: GoogleFonts.outfit(color: Colors.redAccent)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChatBody(BuildContext context, ThemeData theme, bool isDark,
      ConversationDetail conv) {
    Color avatarColor;
    try {
      avatarColor =
          Color(int.parse(conv.senderAvatarColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      avatarColor = Colors.purpleAccent;
    }

    // Scroll to bottom when messages load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return Column(
      children: [
        // Messages List
        Expanded(
          child: conv.messages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 64,
                          color: theme.textTheme.bodyMedium?.color
                              ?.withValues(alpha: 0.2)),
                      const SizedBox(height: 16),
                      Text("Start the conversation",
                          style: GoogleFonts.outfit(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.5))),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: conv.messages.length,
                  itemBuilder: (context, index) => _MessageBubble(
                    message: conv.messages[index],
                    avatarColor: avatarColor,
                    senderInitial: conv.senderName[0],
                  ).animate().fadeIn(duration: 200.ms),
                ),
        ),

        // Input Area
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.cardColor,
            border:
                Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                IconButton(
                  onPressed: _isSending ? null : _pickAndSendAttachment,
                  icon: Icon(Icons.attach_file_rounded,
                      color: _isSending
                          ? Colors.grey.withValues(alpha: 0.5)
                          : Colors.grey,
                      size: 24),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color:
                          isDark ? const Color(0xFF2C2C2C) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _msgController,
                      enabled: !_isSending,
                      style: GoogleFonts.outfit(
                          color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: GoogleFonts.outfit(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isSending ? null : _sendMessage,
                  icon: _isSending
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded,
                          color: Colors.blueAccent, size: 28),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final Color avatarColor;
  final String senderInitial;

  const _MessageBubble({
    required this.message,
    required this.avatarColor,
    required this.senderInitial,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isFromUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isFromUser)
            CircleAvatar(
              radius: 14,
              backgroundColor: avatarColor,
              child: Text(
                senderInitial,
                style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
          if (!message.isFromUser) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isFromUser
                    ? Colors.blueAccent
                    : (theme.brightness == Brightness.dark
                        ? const Color(0xFF2C2C2C)
                        : Colors.grey[200]),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: message.isFromUser
                      ? const Radius.circular(16)
                      : const Radius.circular(2),
                  bottomRight: message.isFromUser
                      ? const Radius.circular(2)
                      : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.attachmentType != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            message.attachmentType == 'image'
                                ? Icons.image
                                : Icons.attach_file,
                            color: message.isFromUser
                                ? Colors.white
                                : theme.iconTheme.color,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Attachment",
                            style: GoogleFonts.outfit(
                              color: message.isFromUser
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : theme.textTheme.bodySmall?.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    message.content,
                    style: GoogleFonts.outfit(
                      color: message.isFromUser
                          ? Colors.white
                          : theme.textTheme.bodyLarge?.color,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.createdAt),
                    style: GoogleFonts.outfit(
                      color: message.isFromUser
                          ? Colors.white54
                          : theme.textTheme.bodySmall?.color
                              ?.withValues(alpha: 0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
