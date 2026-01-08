import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/router/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // Preload Theme
  final prefs = await SharedPreferences.getInstance();
  final isLight = prefs.getBool('theme_mode') ?? false;

  runApp(ProviderScope(
    overrides: [
      themeProvider.overrideWith((ref) => ThemeNotifier(
          initialMode: isLight ? ThemeMode.light : ThemeMode.dark)),
    ],
    child: const DevApp(),
  ));
}

class DevApp extends ConsumerWidget {
  const DevApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
