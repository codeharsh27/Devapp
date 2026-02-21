import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

import '../utils/logger.dart';
import 'network_info.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  final baseUrl = ApiConfig.baseUrl;
  final networkInfo = ref.watch(networkInfoProvider);

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // Add Auth Interceptor & Logging
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Check Connectivity
      if (!await networkInfo.isConnected) {
        handler.reject(
          DioException(
            requestOptions: options,
            error: "No Internet Connection",
            type: DioExceptionType.connectionError,
          ),
        );
        return;
      }

      // ALWAYS use Supabase token
      final supabase = Supabase.instance.client;
      final session = supabase.auth.currentSession;

      if (session != null) {
        options.headers['Authorization'] = 'Bearer ${session.accessToken}';
      } else {
        // Fallback: Check for mock token (Dev Mode Bypass)
        // We can't access ref inside the interceptor easily unless we capture the storage instance,
        // but SecureLocalStorage is available or we can use FlutterSecureStorage directly.
        // Importing here to keep it contained.
        try {
          // ignore: invalid_use_of_visible_for_testing_member
          const storage = FlutterSecureStorage();
          final mockToken = await storage.read(key: 'mock_token');
          if (mockToken != null) {
            Logger.info('DIO: Using MOCK TOKEN for request');
            options.headers['Authorization'] = 'Bearer $mockToken';
          } else {
            Logger.error('DIO: No Supabase session - request may fail auth');
          }
        } catch (e) {
          Logger.error('DIO: Failed to check mock token: $e');
        }
      }

      Logger.info('DIO REQUEST: [${options.method}] ${options.uri}');
      handler.next(options);
    },
    onResponse: (response, handler) {
      Logger.info(
          'DIO RESPONSE: [${response.statusCode}] ${response.requestOptions.uri}');
      handler.next(response);
    },
    onError: (DioException e, handler) async {
      Logger.error(
          'DIO ERROR: [${e.response?.statusCode}] ${e.requestOptions.uri}');
      Logger.error('DIO ERROR MSG: ${e.message}');

      if (e.response?.data != null) {
        Logger.error('DIO ERROR DATA: ${e.response?.data}');
      }

      // Auto-refresh token on 401
      if (e.response?.statusCode == 401) {
        Logger.info('DIO: 401 Unauthorized - Attempting token refresh...');
        try {
          final supabase = Supabase.instance.client;
          final response = await supabase.auth.refreshSession();

          if (response.session != null) {
            Logger.info('DIO: Token refreshed successfully!');
            // Retry the failed request with new token
            final opts = e.requestOptions;
            opts.headers['Authorization'] =
                'Bearer ${response.session!.accessToken}';

            final retryResponse = await dio.fetch(opts);
            return handler.resolve(retryResponse);
          } else {
            Logger.error('DIO: Token refresh returned no session');
          }
        } catch (refreshError) {
          Logger.error('DIO: Token refresh failed: $refreshError');
        }
      }
      handler.next(e);
    },
  ));

  return dio;
}
