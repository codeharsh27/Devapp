import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/router/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/network/websocket_binder.dart';
import 'core/config/api_config.dart';
import 'core/utils/logger.dart';
import 'core/utils/secure_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'core/config/sentry_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  Logger.info('APP START: API Base URL: ${ApiConfig.baseUrl}');

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
    authOptions: const FlutterAuthClientOptions(
      localStorage: SecureLocalStorage(),
    ),
  );

  // Preload Theme
  final prefs = await SharedPreferences.getInstance();
  final isLight = prefs.getBool('theme_mode') ?? false;

  await SentryFlutter.init(
    (options) {
      options.dsn = SentryConfig.dsn;
      options.tracesSampleRate = SentryConfig.tracesSampleRate;
    },
    appRunner: () => runApp(ProviderScope(
      overrides: [
        themeProvider.overrideWith((ref) => ThemeNotifier(
            initialMode: isLight ? ThemeMode.light : ThemeMode.dark)),
      ],
      child: const DevApp(),
    )),
  );
}

class DevApp extends ConsumerWidget {
  const DevApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(webSocketBinderProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'DevApp',
      themeMode: ref.watch(themeProvider),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
