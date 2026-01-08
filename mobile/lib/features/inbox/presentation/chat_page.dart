import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String senderName;
  final String senderRole;
  final Color avatarColor;

  const ChatPage({
    super.key,
    required this.senderName,
    required this.senderRole,
    required this.avatarColor,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<MessageBubble> _messages = [];
  int _messageCount = 0;
  final int _maxMessages = 5;

  @override
  void initState() {
    super.initState();
    // Simulate initial message based on Role
    String initialMsg =
        "Hi! I saw your profile and your recent 'Vector Database' submission. It was impressive. We are looking for someone with your skills for a Gig.";

    if (widget.senderRole == "Team Lead") {
      initialMsg =
          "Hey, can you update me on the status of the 'Payment Gateway' integration? We need it by EOD.";
    } else if (widget.senderRole == "Founder") {
      initialMsg =
          "Great work on the latest drop! I have a new idea for a feature I'd like to discuss with you.";
    }

    _messages.add(
      MessageBubble(
        text: initialMsg,
        isMe: false,
        time: "10:30 AM",
        avatarColor: widget.avatarColor,
      ),
    );
  }

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    if (_messageCount >= _maxMessages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Message limit reached. Wait for reply.",
              style: GoogleFonts.outfit()),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _messages.add(
        MessageBubble(
          text: _msgController.text,
          isMe: true,
          time: "Now",
          avatarColor: widget.avatarColor, // Not used for 'Me' but passed
        ),
      );
      _messageCount++;
      _msgController.clear();
    });

    // Auto scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _pickFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _messages.add(MessageBubble(
          text: "Sent an attachment: ${image.name}",
          isMe: true,
          time: "Now",
          avatarColor: widget.avatarColor,
          isAttachment: true,
        ));
        _messageCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
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
              backgroundColor: widget.avatarColor,
              radius: 16,
              child: Text(widget.senderName[0],
                  style: GoogleFonts.outfit(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.senderName,
                    style: GoogleFonts.outfit(
                        color: theme.textTheme.titleLarge?.color,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                Text(widget.senderRole,
                    style: GoogleFonts.outfit(
                        color: theme.textTheme.bodySmall?.color, fontSize: 10)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: theme.iconTheme.color),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),

          // Limits Warning
          if (_messageCount >= 3)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "${_maxMessages - _messageCount} messages left in this session",
                style: GoogleFonts.outfit(
                    color: Colors.orangeAccent, fontSize: 10),
              ),
            ),

          // Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(
                  top: BorderSide(color: theme.dividerColor, width: 0.5)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file_rounded,
                      color: Colors.grey, size: 24),
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
                      style: GoogleFonts.outfit(
                          color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: GoogleFonts.outfit(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send_rounded,
                      color: Colors.blueAccent, size: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;
  final Color avatarColor;
  final bool isAttachment;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
    required this.avatarColor,
    this.isAttachment = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 14,
              backgroundColor: avatarColor,
              child: Text(
                "R", // Initials could be passed
                style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
          if (!isMe) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? Colors.blueAccent : const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe
                      ? const Radius.circular(16)
                      : const Radius.circular(2),
                  bottomRight: isMe
                      ? const Radius.circular(2)
                      : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isAttachment)
                    Row(children: [
                      const Icon(Icons.image, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text("Attachment",
                              style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                    ]),
                  Text(
                    text,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: GoogleFonts.outfit(
                      color: Colors.white54,
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
}
