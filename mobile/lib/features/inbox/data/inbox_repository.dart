import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_provider.dart';
import '../domain/conversation.dart';
import '../../../core/utils/logger.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'inbox_repository.g.dart';

@riverpod
class InboxRepository extends _$InboxRepository {
  @override
  Dio build() {
    return ref.watch(dioProvider);
  }

  /// Get all conversations for the current user
  Future<List<Conversation>> getConversations({String? messageType}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (messageType != null) {
        queryParams['message_type'] = messageType;
      }

      final response = await state.get('/inbox', queryParameters: queryParams);
      final List data = response.data;
      return data.map((e) => Conversation.fromJson(e)).toList();
    } catch (e) {
      Logger.error('Error fetching conversations: $e');
      rethrow;
    }
  }

  /// Get a specific conversation with all messages
  Future<ConversationDetail> getConversation(int conversationId) async {
    try {
      final response = await state.get('/inbox/$conversationId');
      return ConversationDetail.fromJson(response.data);
    } catch (e) {
      Logger.error('Error fetching conversation: $e');
      rethrow;
    }
  }

  /// Send a message in a conversation
  Future<Message> sendMessage({
    required int conversationId,
    required String content,
    String? attachmentUrl,
    String? attachmentType,
  }) async {
    try {
      final response = await state.post(
        '/inbox/$conversationId/messages',
        data: {
          'content': content,
          if (attachmentUrl != null) 'attachment_url': attachmentUrl,
          if (attachmentType != null) 'attachment_type': attachmentType,
        },
      );
      return Message.fromJson(response.data);
    } catch (e) {
      Logger.error('Error sending message: $e');
      rethrow;
    }
  }

  /// Delete a conversation
  Future<void> deleteConversation(int conversationId) async {
    try {
      await state.delete('/inbox/$conversationId');
    } catch (e) {
      Logger.error('Error deleting conversation: $e');
      rethrow;
    }
  }
}

/// Provider for conversations list
@riverpod
Future<List<Conversation>> conversationsList(Ref ref,
    {String? messageType}) async {
  return ref
      .watch(inboxRepositoryProvider.notifier)
      .getConversations(messageType: messageType);
}

/// Provider for a single conversation detail
@riverpod
Future<ConversationDetail> conversationDetail(
    Ref ref, int conversationId) async {
  return ref
      .watch(inboxRepositoryProvider.notifier)
      .getConversation(conversationId);
}
