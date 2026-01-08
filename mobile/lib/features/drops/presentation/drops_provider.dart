import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/drop.dart';
import '../data/drops_repository.dart';

part 'drops_provider.g.dart';

@riverpod
class DropsList extends _$DropsList {
  @override
  FutureOr<List<Drop>> build() {
    return ref.watch(dropsRepositoryProvider.notifier).getDrops();
  }
}
