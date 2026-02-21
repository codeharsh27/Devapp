import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../domain/user_profile.dart';

part 'user_profile_provider.g.dart';

@riverpod
Future<UserProfile> userProfile(Ref ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/users/me');
  return UserProfile.fromJson(response.data);
}
