import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../drops/data/drops_repository.dart';
import '../../drops/domain/activity_entry.dart';

part 'activity_provider.g.dart';

@riverpod
class GlobalActivity extends _$GlobalActivity {
  @override
  Future<List<ActivityEntry>> build() {
    return ref.watch(dropsRepositoryProvider.notifier).getGlobalActivity();
  }
}
