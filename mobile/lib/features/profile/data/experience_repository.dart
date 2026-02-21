import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/experience_model.dart';
import '../../../core/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'experience_repository.g.dart';

@riverpod
class ExperienceRepository extends _$ExperienceRepository {
  @override
  FutureOr<List<Experience>> build() async {
    return await getExperiences();
  }

  Dio get _dio => ref.read(dioProvider);

  /// Get all experiences for the current user
  Future<List<Experience>> getExperiences() async {
    try {
      final response = await _dio.get('/experiences/');
      return (response.data as List)
          .map((e) => Experience.fromJson(e))
          .toList();
    } catch (e) {
      Logger.error('Experience: Error fetching experiences: $e');
      return [];
    }
  }

  /// Get featured experiences for profile display (top 3)
  Future<List<ExperienceSummary>> getFeaturedExperiences(
      {int limit = 3}) async {
    try {
      final response =
          await _dio.get('/experiences/featured', queryParameters: {
        'limit': limit,
      });
      return (response.data as List)
          .map((e) => ExperienceSummary.fromJson(e))
          .toList();
    } catch (e) {
      Logger.error('Experience: Error fetching featured: $e');
      return [];
    }
  }

  /// Create a new experience
  Future<Experience?> createExperience(ExperienceCreate experience) async {
    try {
      final response = await _dio.post(
        '/experiences/',
        data: experience.toJson(),
      );

      // Refresh the list
      ref.invalidateSelf();

      return Experience.fromJson(response.data);
    } catch (e) {
      Logger.error('Experience: Error creating: $e');
      return null;
    }
  }

  /// Update an experience
  Future<Experience?> updateExperience(
      int id, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.put(
        '/experiences/$id',
        data: updates,
      );

      // Refresh the list
      ref.invalidateSelf();

      return Experience.fromJson(response.data);
    } catch (e) {
      Logger.error('Experience: Error updating: $e');
      return null;
    }
  }

  /// Delete an experience
  Future<bool> deleteExperience(int id) async {
    try {
      await _dio.delete('/experiences/$id');

      // Refresh the list
      ref.invalidateSelf();

      return true;
    } catch (e) {
      Logger.error('Experience: Error deleting: $e');
      return false;
    }
  }

  /// Toggle featured status
  Future<Experience?> toggleFeatured(int id) async {
    try {
      final response = await _dio.post('/experiences/$id/toggle-featured');

      // Refresh the list
      ref.invalidateSelf();

      return Experience.fromJson(response.data);
    } catch (e) {
      Logger.error('Experience: Error toggling featured: $e');
      return null;
    }
  }
}

/// Provider for featured experiences (for profile section)
@riverpod
Future<List<ExperienceSummary>> featuredExperiences(Ref ref) async {
  return ref
      .read(experienceRepositoryProvider.notifier)
      .getFeaturedExperiences();
}
