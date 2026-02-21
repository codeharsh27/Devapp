import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state_provider.g.dart';

@riverpod
Stream<Session?> authState(Ref ref) {
  return Supabase.instance.client.auth.onAuthStateChange
      .map((event) => event.session);
}
