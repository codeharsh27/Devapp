import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/network/dio_provider.dart';

part 'auth_service.g.dart';

@riverpod
class AuthService extends _$AuthService {
  @override
  FutureOr<void> build() {}

  // Helper getter for Supabase client
  SupabaseClient get _supabase => Supabase.instance.client;

  Future<void> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw Exception('Login failed: unknown error');
      }
    } catch (e) {
      // Improve error handling suitable for UI
      rethrow;
    }
  }

  Future<void> register(String email, String password, {String? name}) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: name != null ? {'full_name': name} : null,
      );
      if (response.user == null) {
        throw Exception('Registration failed: unknown error');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  Future<void> deleteAccount() async {
    final dio = ref.read(dioProvider);
    try {
      await dio.delete('/users/me');
    } catch (e) {
      // Ignore if already deleted or network error, proceeding to sign out
      // But rethrow if important? For now log and continue
    }
    await _supabase.auth.signOut();
  }

  Future<String?> getToken() async {
    final session = _supabase.auth.currentSession;
    return session?.accessToken;
  }

  Future<bool> isLoggedIn() async {
    return _supabase.auth.currentUser != null;
  }
}
