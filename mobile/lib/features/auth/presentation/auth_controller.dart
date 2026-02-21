import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/dio_provider.dart';
import '../data/auth_service.dart';
import 'auth_provider.dart';
import '../../../../core/utils/logger.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // nothing to initialize
  }

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authServiceProvider.notifier).login(email, password);

      // Check for temporary class selection and sync to backend if present
      await _syncTempClassSelection();

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> register(String email, String password, {String? name}) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(authServiceProvider.notifier)
          .register(email, password, name: name);

      // Check for temporary class selection and sync to backend if present
      await _syncTempClassSelection();

      // Note: If email confirmation is enabled in Supabase, the user won't be logged in yet.
      // If disabled, they are logged in. We'll assume success redirects.

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> _syncTempClassSelection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tempClassId = prefs.getString('temp_selected_class_id');

      if (tempClassId != null) {
        // We have a pending class selection. Sync it to backend.
        // We assume we are logged in now (AuthService.register acts as login if auto-confirm is off/mocked)
        // However, we need to ensure the SESSION is available for Dio.
        // A small delay might be needed for state propagation or we trust the interceptor.

        final dio = ref.read(dioProvider);
        await dio.post('/users/me/class', data: {
          'domain': tempClassId,
        });

        // Clear the temp value so we don't re-set it later inadvertently
        await prefs.remove('temp_selected_class_id');
      }
    } catch (e) {
      // Don't fail the registration if this optional step fails,
      // but maybe log it. User can re-select later.
      Logger.error('Failed to sync temp class: $e');
    }
  }

  Future<void> logout() async {
    await ref.read(authServiceProvider.notifier).logout();
    state = const AsyncValue.data(null);
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authProvider.notifier).deleteAccount();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
