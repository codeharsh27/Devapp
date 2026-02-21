import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // For StreamSubscription
import '../../features/auth/presentation/auth_provider.dart';
import '../../features/home/presentation/main_wrapper_page.dart';
import '../../features/drops/presentation/home_page.dart';
import '../../features/drops/presentation/explore_page.dart';
import '../../features/drops/presentation/drop_detail_page.dart';
import '../../features/drops/presentation/domain_drops_page.dart';
import '../../features/drops/presentation/active_execution_page.dart';
import '../../features/drops/domain/drop.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/signup_page.dart';
import '../../features/auth/presentation/splash_page.dart';
import '../../features/inbox/presentation/inbox_page.dart';
import '../../features/notifications/presentation/notifications_page.dart';
import '../../features/drops/presentation/my_drops_page.dart';
import '../../features/inbox/presentation/chat_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/profile/presentation/edit_profile_page.dart';
import '../../features/profile/presentation/experience_page.dart';
import '../../features/profile/presentation/terms_page.dart';
import '../../features/profile/presentation/earnings_page.dart';
import '../../features/profile/presentation/settings_page.dart';
import '../../features/subscription/presentation/subscription_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/select_class_page.dart';
import '../../features/leaderboard/presentation/leaderboard_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Use a ValueNotifier to trigger refreshes
  final refreshNotifier = ValueNotifier<bool>(false);

  ref.listen(authProvider, (_, __) {
    refreshNotifier.value = !refreshNotifier.value;
  });

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshNotifier,
    redirect: (context, state) async {
      final authState = ref.read(authProvider);
      final isLoggedIn = authState.value != null;
      final path = state.uri.toString();

      final isPublicRoute =
          path == '/login' || path == '/signup' || path == '/onboarding';
      // path == '/select-class' is effectively protected as it needs auth to save

      if (authState.isLoading) return null;

      // 1. Logged In User
      if (isLoggedIn) {
        // If user is on a public page (Login/Signup), send to Splash ('/')
        // Splash will check profile & class selection, then route to Home or Select-Class
        if (isPublicRoute) return '/';

        // If user is on Splash ('/'), allow it to run logic
        if (path == '/') return null;

        return null;
      }

      // 2. Guest User
      if (!isLoggedIn) {
        if (isPublicRoute) return null;

        if (path == '/') {
          return '/onboarding';
        }

        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/chat/:conversationId',
        builder: (context, state) {
          final conversationId =
              int.parse(state.pathParameters['conversationId']!);
          return ChatPage(conversationId: conversationId);
        },
      ),
      // ShellRoute for Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => MainWrapperPage(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/submissions',
            builder: (context, state) => const MyDropsPage(),
          ),
          GoRoute(
            path: '/inbox',
            builder: (context, state) => const InboxPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/explore',
            builder: (context, state) => const ExplorePage(),
          ),
        ],
      ),
      GoRoute(
        path: '/drop',
        pageBuilder: (context, state) {
          final drop = state.extra as Drop;
          return CustomTransitionPage(
            key: state.pageKey,
            child: DropDetailPage(drop: drop),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/execution',
        pageBuilder: (context, state) {
          final drop = state.extra as Drop;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ActiveExecutionPage(drop: drop),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/experience',
        builder: (context, state) => const ExperiencePage(),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const TermsPage(),
      ),
      GoRoute(
        path: '/earnings',
        builder: (context, state) => const EarningsPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/subscription',
        builder: (context, state) => const SubscriptionPage(),
      ),
      GoRoute(
        path: '/select-class',
        builder: (context, state) => const SelectClassPage(),
      ),

      GoRoute(
        path: '/domain-feed',
        builder: (context, state) {
          final domain = state.extra as String? ?? 'backend';
          return DomainDropsPage(domainId: domain);
        },
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardPage(),
      ),
    ],
  );
});

// Helper for GoRouter Refresh Listenable
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
