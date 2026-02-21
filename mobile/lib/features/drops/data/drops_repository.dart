import 'package:mobile/features/drops/domain/leaderboard_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_provider.dart';
import '../domain/drop.dart';
import '../domain/submission.dart';
import '../domain/user_model.dart';
import '../domain/activity_entry.dart';
import '../../../core/utils/logger.dart';

part 'drops_repository.g.dart';

@riverpod
class DropsRepository extends _$DropsRepository {
  @override
  Dio build() {
    return ref.watch(dioProvider);
  }

  Future<List<ActivityEntry>> getGlobalActivity() async {
    try {
      final response = await state.get('/users/activity/global');
      final List data = response.data;
      return data.map((e) => ActivityEntry.fromJson(e)).toList();
    } catch (e) {
      Logger.error("Failed to fetch global activity", error: e);
      return []; // Return empty for UI resilience, but log error
    }
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

  Future<User> getMe() async {
    try {
      final response = await state.get('/users/me');
      return User.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserStats> getUserStats() async {
// ...
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
      Logger.error(
          'Submit Error: ${e.response?.statusCode} - ${e.response?.data}');
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deployDrop(int dropId) async {
    try {
      await state.post('/drops/$dropId/deploy');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? fullName,
    String? bio,
    String? upiId,
    String? avatarUrl,
    Map<String, String>? socialLinks,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (fullName != null) data['full_name'] = fullName;
      if (bio != null) data['bio'] = bio;
      if (upiId != null) data['upi_id'] = upiId;
      if (avatarUrl != null) data['avatar_url'] = avatarUrl;
      if (socialLinks != null) data['social_links'] = socialLinks;

      if (data.isEmpty) return;

      await state.put('/users/me', data: data);

      // Force refresh of stats/profile data if cached
      ref.invalidateSelf();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<DateTime, int>> getUserActivity() async {
    try {
      final response = await state.get('/users/me/activity');
      final Map<String, dynamic> data = response.data;

      return data.map((key, value) {
        final date = DateTime.parse(key);
        // Ensure date is UTC/Local consistent if needed, mostly we just need YMD
        return MapEntry(
            DateTime(date.year, date.month, date.day), value as int);
      });
    } catch (e) {
      return {};
    }
  }

  Future<List<LeaderboardEntry>> getLeaderboard({String? domain}) async {
    try {
      final response = await state.get(
        '/users/leaderboard',
        queryParameters: domain != null ? {'domain': domain} : null,
      );
      final List data = response.data;
      return data.map((e) => LeaderboardEntry.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Submission>> getMySubmissions() async {
    try {
      final response = await state.get('/users/me/submissions');
      final List data = response.data;
      return data.map((e) => Submission.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
