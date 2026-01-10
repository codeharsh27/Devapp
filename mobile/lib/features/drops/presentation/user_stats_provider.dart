import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/user_model.dart';
import '../data/drops_repository.dart';

part 'user_stats_provider.g.dart';

@riverpod
Future<UserStats> userStats(UserStatsRef ref) {
  return ref.watch(dropsRepositoryProvider.notifier).getUserStats();
}
