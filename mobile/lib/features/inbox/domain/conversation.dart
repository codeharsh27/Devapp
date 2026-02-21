import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required int id,
    @JsonKey(name: 'sender_name') required String senderName,
    @JsonKey(name: 'sender_role') String? senderRole,
    @JsonKey(name: 'sender_avatar_color')
    @Default('#6366F1')
    String senderAvatarColor,
    @JsonKey(name: 'message_type') @Default('general') String messageType,
    String? subject,
    @JsonKey(name: 'last_message') String? lastMessage,
    @JsonKey(name: 'last_message_time') DateTime? lastMessageTime,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'unread_count') @Default(0) int unreadCount,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}

@freezed
class ConversationDetail with _$ConversationDetail {
  const factory ConversationDetail({
    required int id,
    @JsonKey(name: 'sender_name') required String senderName,
    @JsonKey(name: 'sender_role') String? senderRole,
    @JsonKey(name: 'sender_email') String? senderEmail,
    @JsonKey(name: 'sender_avatar_color')
    @Default('#6366F1')
    String senderAvatarColor,
    @JsonKey(name: 'message_type') @Default('general') String messageType,
    String? subject,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @Default([]) List<Message> messages,
  }) = _ConversationDetail;

  factory ConversationDetail.fromJson(Map<String, dynamic> json) =>
      _$ConversationDetailFromJson(json);
}

@freezed
class Message with _$Message {
  const factory Message({
    required int id,
    @JsonKey(name: 'conversation_id') required int conversationId,
    @JsonKey(name: 'is_from_user') required bool isFromUser,
    required String content,
    @JsonKey(name: 'attachment_url') String? attachmentUrl,
    @JsonKey(name: 'attachment_type') String? attachmentType,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
