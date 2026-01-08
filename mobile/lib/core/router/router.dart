import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../features/home/presentation/main_wrapper_page.dart';
import '../../features/drops/presentation/home_page.dart';
import '../../features/drops/presentation/drop_detail_page.dart';
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

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
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
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return ChatPage(
              senderName: extras['senderName'],
              senderRole: extras['senderRole'],
              avatarColor: extras['avatarColor']);
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
    ],
  );
});
