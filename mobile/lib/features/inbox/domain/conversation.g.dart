// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationImpl _$$ConversationImplFromJson(Map<String, dynamic> json) =>
    _$ConversationImpl(
      id: (json['id'] as num).toInt(),
      senderName: json['sender_name'] as String,
      senderRole: json['sender_role'] as String?,
      senderAvatarColor: json['sender_avatar_color'] as String? ?? '#6366F1',
      messageType: json['message_type'] as String? ?? 'general',
      subject: json['subject'] as String?,
      lastMessage: json['last_message'] as String?,
      lastMessageTime: json['last_message_time'] == null
          ? null
          : DateTime.parse(json['last_message_time'] as String),
      isRead: json['is_read'] as bool? ?? false,
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ConversationImplToJson(_$ConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender_name': instance.senderName,
      'sender_role': instance.senderRole,
      'sender_avatar_color': instance.senderAvatarColor,
      'message_type': instance.messageType,
      'subject': instance.subject,
      'last_message': instance.lastMessage,
      'last_message_time': instance.lastMessageTime?.toIso8601String(),
      'is_read': instance.isRead,
      'unread_count': instance.unreadCount,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$ConversationDetailImpl _$$ConversationDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationDetailImpl(
      id: (json['id'] as num).toInt(),
      senderName: json['sender_name'] as String,
      senderRole: json['sender_role'] as String?,
      senderEmail: json['sender_email'] as String?,
      senderAvatarColor: json['sender_avatar_color'] as String? ?? '#6366F1',
      messageType: json['message_type'] as String? ?? 'general',
      subject: json['subject'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ConversationDetailImplToJson(
        _$ConversationDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender_name': instance.senderName,
      'sender_role': instance.senderRole,
      'sender_email': instance.senderEmail,
      'sender_avatar_color': instance.senderAvatarColor,
      'message_type': instance.messageType,
      'subject': instance.subject,
      'is_read': instance.isRead,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'messages': instance.messages,
    };

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: (json['id'] as num).toInt(),
      conversationId: (json['conversation_id'] as num).toInt(),
      isFromUser: json['is_from_user'] as bool,
      content: json['content'] as String,
      attachmentUrl: json['attachment_url'] as String?,
      attachmentType: json['attachment_type'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'is_from_user': instance.isFromUser,
      'content': instance.content,
      'attachment_url': instance.attachmentUrl,
      'attachment_type': instance.attachmentType,
      'created_at': instance.createdAt.toIso8601String(),
      'is_read': instance.isRead,
    };
