import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/auth_service.dart';

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

      // Note: If email confirmation is enabled in Supabase, the user won't be logged in yet.
      // If disabled, they are logged in. We'll assume success redirects.

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> logout() async {
    await ref.read(authServiceProvider.notifier).logout();
    state = const AsyncValue.data(null);
  }
}
