import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_provider.dart';
import '../domain/drop.dart';
import '../domain/submission.dart';
import '../domain/user_model.dart';

part 'drops_repository.g.dart';

@riverpod
class DropsRepository extends _$DropsRepository {
  @override
  Dio build() {
    return ref.watch(dioProvider);
  }

  Future<List<Drop>> getDrops() async {
    try {
      final response = await state.get('/drops');
      final List data = response.data;
      return data.map((e) => Drop.fromJson(e)).toList();
    } catch (e) {
      // Handle errors properly in production
      rethrow;
    }
  }

  Future<Submission> getSubmission(int submissionId) async {
    try {
      final response = await state.get('/submissions/$submissionId');
      return Submission.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserStats> getUserStats() async {
    try {
      final response = await state.get('/users/me/stats');
      return UserStats.fromJson(response.data);
    } catch (e) {
      // Remove mock stats to fail fast if Auth is broken
      rethrow;
    }
  }

  Future<Submission> submitDrop({
    required int dropId,
    required String submissionUrl,
    String? docUrl,
    String? imageUrl,
  }) async {
    try {
      final response = await state.post('/submit', data: {
        'drop_id': dropId,
        'submission_url': submissionUrl,
        'doc_url': docUrl,
        'image_url': imageUrl,
      });
      return Submission.fromJson(response.data);
    } on DioException catch (e) {
      print('Submit Error: ${e.response?.statusCode} - ${e.response?.data}');
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
