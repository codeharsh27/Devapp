import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/websocket_service.dart';
import '../domain/user_model.dart';
import '../data/drops_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'user_stats_provider.g.dart';

@riverpod
Future<UserStats> userStats(Ref ref) async {
  // Auto-refresh stats when a submission update is received
  ref.listen(webSocketEventsProvider, (prev, next) {
    next.whenData((event) {
      if (event['type'] == 'submission_update') {
        // Invalidate self to re-fetch fresh stats from API
        ref.invalidateSelf();
      }
    });
  });

  return ref.watch(dropsRepositoryProvider.notifier).getUserStats();
}
