import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_event.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_state.dart';
import 'package:blog_app/feature/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:blog_app/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feature/blog/presentation/bloc/blog_bloc.dart';
import 'feature/job/presentation/bloc/job_bloc.dart';
import 'package:blog_app/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:blog_app/feature/resume/presentation/cubit/resume_builder_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/feature/auth/presentation/page/login_page.dart';
import 'package:blog_app/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initDependency();
  final prefs = await SharedPreferences.getInstance();
  final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<BlogBloc>()),
        BlocProvider(create: (_) => serviceLocator<JobBloc>()),
        BlocProvider(create: (_) => serviceLocator<ResumeBuilderCubit>()),
        BlocProvider(create: (_) => serviceLocator<ProfileBloc>()),
      ],
      child: BlogApp(onboardingComplete: onboardingComplete),
    ),
  );
}

class BlogApp extends StatefulWidget {
  final bool onboardingComplete;
  const BlogApp({super.key, required this.onboardingComplete});

  @override
  State<BlogApp> createState() => _BlogAppState();
}

class _BlogAppState extends State<BlogApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCurrentUser());
    context.read<JobBloc>().add(JobFetchAllJobs());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Devapp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: AppPallete.primaryColor,
          secondary: AppPallete.secondaryColor,
          surface: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.black87, size: 24.0),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black87, size: 24.0),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedIconTheme: IconThemeData(size: 24.0),
          unselectedIconTheme: IconThemeData(size: 22.0),
        ),
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            FlutterNativeSplash.remove();
            return MainPage();
          } else if (state is AuthFailure) {
            FlutterNativeSplash.remove();
            if (widget.onboardingComplete) {
              return const LoginPage();
            }
            return const OnboardingPage();
          } else if (state is AuthLoading) {
            return const Loader();
          }
          // Initial state or unexpected state
          return const Loader();
        },
      ),
    );
  }
}
