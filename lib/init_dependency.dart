import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/feature/auth/data/datasources/auth_supabase_datasource.dart';
import 'package:blog_app/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/feature/auth/domain/usecases/current_user.dart';
import 'package:blog_app/feature/auth/domain/usecases/user_signin.dart';
import 'package:blog_app/feature/auth/domain/usecases/user_signup.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/feature/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/feature/blog/data/datasources/blog_remotedata.dart';
import 'package:blog_app/feature/blog/data/repositories/blog_repository_impl.dart';
import 'package:blog_app/feature/blog/domain/repository/blog_repository.dart';
import 'package:blog_app/feature/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/feature/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/feature/job/data/datasources/job_local_data_source.dart';
import 'package:blog_app/feature/job/data/datasources/job_remote_data_source.dart';
import 'package:blog_app/feature/job/data/repositories/job_repository_impl.dart';
import 'package:blog_app/feature/job/domain/repository/job_repository.dart';
import 'package:blog_app/feature/job/domain/usecase/get_jobs.dart';
import 'package:blog_app/feature/job/domain/usecase/skill_matcher.dart';
import 'package:blog_app/feature/resume/data/datasources/resume_local_datasource.dart';
import 'package:blog_app/feature/resume/domain/services/pdf_service.dart';
import 'package:blog_app/feature/job/presentation/bloc/job_bloc.dart';
import 'package:blog_app/feature/resume/presentation/cubit/resume_builder_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:blog_app/feature/auth/domain/usecases/user_social_login.dart';
import 'package:blog_app/feature/profile/data/datasources/profile_remote_data_source.dart';
import 'package:blog_app/feature/profile/data/repositories/profile_repository_impl.dart';
import 'package:blog_app/feature/profile/domain/repositories/profile_repository.dart';
import 'package:blog_app/feature/profile/domain/usecases/get_user_profile.dart';
import 'package:blog_app/feature/profile/domain/usecases/update_user_profile.dart';
import 'package:blog_app/feature/profile/domain/usecases/upload_profile_image.dart';
import 'package:blog_app/feature/profile/presentation/bloc/profile_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependency() async {
  _initAuth();
  _initBlog();
  _initProfile();
  final supabase = await Supabase.initialize(
    url: AppSecrets.url,
    anonKey: AppSecrets.anonKey,
  );

  await Hive.initFlutter();

  serviceLocator.registerLazySingleton(() => supabase.client);

  await Hive.openBox('blogs');
  serviceLocator.registerLazySingleton(() => Hive.box('blogs'));

  serviceLocator.registerFactory(() => InternetConnection());

  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);

  /// core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(
    () => ResumeLocalDataSource(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ResumeBuilderCubit(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => PdfService());
  _initJob();
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthSupabaseSource>(
      () => AuthSupabaseSourceImpl(serviceLocator()),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoriesImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserSignIn(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerFactory(() => UserSocialLogin(serviceLocator()))
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
        userSocialLogin: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    ..registerLazySingleton(
      () =>
          BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()),
    );
}

void _initJob() {
  // Datasources
  serviceLocator
    ..registerFactory<JobLocalDataSource>(
      () => JobLocalDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<JobRemoteDataSource>(
      () => JSearchRemoteDataSource(serviceLocator()),
      instanceName: 'jsearch',
    )
    ..registerFactory<JobRemoteDataSource>(
      () => RemotiveRemoteDataSource(serviceLocator()),
      instanceName: 'remotive',
    )
    ..registerFactory<JobRemoteDataSource>(
      () => FindWorkRemoteDataSource(serviceLocator()),
      instanceName: 'findwork',
    );

  // Repository
  serviceLocator.registerFactory<JobRepository>(
    () => JobRepositoryImpl(
      serviceLocator(),
      serviceLocator(instanceName: 'jsearch'),
      serviceLocator(instanceName: 'remotive'),
      serviceLocator(instanceName: 'findwork'),
      serviceLocator(),
    ),
  );

  // Usecases
  serviceLocator.registerFactory(() => GetJobs(serviceLocator()));
  serviceLocator.registerFactory(() => SkillMatcher());

  // Bloc
  serviceLocator.registerLazySingleton(
    () => JobBloc(
      getJobs: serviceLocator(),
      skillMatcher: serviceLocator(),
      appUserCubit: serviceLocator(),
      jobRepository: serviceLocator(),
    ),
  );
}

void _initProfile() {
  serviceLocator
    ..registerFactory<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<ProfileRepository>(
      () => ProfileRepositoryImpl(serviceLocator()),
    )
    ..registerFactory(() => UpdateUserProfile(serviceLocator()))
    ..registerFactory(() => UploadProfileImage(serviceLocator()))
    ..registerFactory(() => GetUserProfile(serviceLocator()))
    ..registerLazySingleton(
      () => ProfileBloc(
        updateUserProfile: serviceLocator(),
        uploadProfileImage: serviceLocator(),
        getUserProfile: serviceLocator(),
      ),
    );
}
