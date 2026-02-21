import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'websocket_service.dart';

final webSocketBinderProvider = Provider<void>((ref) {
  final wsService = ref.read(webSocketServiceProvider);

  // Listen to Supabase Auth Changes
  // We use .listen and return subscription to clean up
  final subscription =
      Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final session = data.session;
    if (session != null) {
      wsService.connect(session.accessToken);
    } else {
      wsService.disconnect();
    }
  });

  // Perform initial check
  final initialSession = Supabase.instance.client.auth.currentSession;
  if (initialSession != null) {
    wsService.connect(initialSession.accessToken);
  }

  ref.onDispose(() {
    subscription.cancel();
    wsService.disconnect();
  });
});
