import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../drops/data/drops_repository.dart';
import '../../drops/domain/submission.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'user_submissions_provider.g.dart';

@riverpod
Future<List<Submission>> userSubmissions(Ref ref) async {
  return ref.watch(dropsRepositoryProvider.notifier).getMySubmissions();
}
