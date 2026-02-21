import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../profile/data/user_profile_provider.dart';
import '../data/auth_service.dart';
import '../../../../core/utils/logger.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Add a slight delay to show branding or ensure storage is ready
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Check if user has seen onboarding
    final prefs = await SharedPreferences.getInstance();

    // FORCE ONBOARDING (Debug Fix)
    // final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;
    const seenOnboarding = false;

    if (!mounted) return;

    // Check auth status
    final isLoggedIn =
        await ref.read(authServiceProvider.notifier).isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      // Sync with Backend
      try {
        final profile = await ref.read(userProfileProvider.future);

        if (!mounted) return;

        // Check if any domain has XP > 0 (implies class selected)
        final hasClass = profile.xpBreakdown.isNotEmpty &&
            profile.xpBreakdown.values.any((v) => (v is num) && v > 0);

        if (hasClass) {
          await prefs.setBool('has_selected_class', true);
          if (mounted) context.go('/home');
        } else {
          await prefs.setBool('has_selected_class', false);
          if (mounted) context.go('/select-class');
        }
      } catch (e) {
        Logger.error("Splash Profile Fetch Error: $e");

        if (!mounted) return;

        // If 401 or similar auth error, logout and go to onboarding
        if (e.toString().contains("401") || e.toString().contains("Auth")) {
          await ref.read(authServiceProvider.notifier).logout();
          if (mounted) context.go('/onboarding');
          return;
        }

        // Fallback for non-auth errors (offline etc)
        final hasSelectedClass = prefs.getBool('has_selected_class') ?? false;
        if (mounted) {
          if (hasSelectedClass) {
            context.go('/home');
          } else {
            context.go('/select-class');
          }
        }
      }
    } else if (!seenOnboarding) {
      context.go('/onboarding');
    } else {
      // Seen onboarding, but not logged in.
      // Check if they have selected a class temporarily
      final tempClass = prefs.getString('temp_selected_class_id');

      if (tempClass != null) {
        // Go to signup to finish process
        context.go('/signup');
      } else {
        // Go to Select Class
        context.go('/select-class');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.code, size: 80, color: Colors.blueAccent),
            SizedBox(height: 24),
            CircularProgressIndicator(color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}
