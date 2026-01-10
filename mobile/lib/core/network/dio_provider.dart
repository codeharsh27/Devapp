import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  // CONFIGURATION
  // ---------------------------------------------------------------------------
  // 1. PRODUCTION URL
  //    Used when app is built in release mode.
  const String productionUrl = 'https://api.devapp.com';

  // 2. LOCAL DEVELOPMENT URL (Physical Device)
  //    Run `ipconfig` (Windows) or `ifconfig` (Mac/Linux) to find your IPv4.
  //    Your phone must be on the same WiFi network.
  //    Ensure backend runs with `--host 0.0.0.0`.
  const String localLanIp = 'http://10.143.160.149:8000';

  // 3. EMULATOR URL
  //    Standard Android Emulator IP that maps to host localhost.
  // ignore: unused_local_variable
  const String emulatorIp = 'http://10.0.2.2:8000';
  // ---------------------------------------------------------------------------

  String baseUrl;

  if (kReleaseMode) {
    baseUrl = productionUrl;
  } else {
    // Allow overriding via command line: flutter run --dart-define=API_URL=http://...
    const envUrl = String.fromEnvironment('API_URL');

    if (envUrl.isNotEmpty) {
      baseUrl = envUrl;
    } else if (Platform.isAndroid) {
      // For Android, we typically default to LAN IP to support Physical Devices.
      // If you are ONLY using Emulator, you can switch this to `emulatorIp`.
      baseUrl = localLanIp;
    } else {
      // iOS / Desktop / Web
      baseUrl = 'http://127.0.0.1:8000';
    }
  }

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  // Add Auth Interceptor & Logging
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Use Supabase Token
      final token = Supabase.instance.client.auth.currentSession?.accessToken;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      print('DIO REQUEST: [${options.method}] ${options.uri}');
      print('DIO HEADERS: ${options.headers}');
      handler.next(options);
    },
    onResponse: (response, handler) {
      print(
          'DIO RESPONSE: [${response.statusCode}] ${response.requestOptions.uri}');
      handler.next(response);
    },
    onError: (DioException e, handler) {
      print('DIO ERROR: [${e.response?.statusCode}] ${e.requestOptions.uri}');
      print('DIO ERROR MSG: ${e.message}');
      print('DIO ERROR DATA: ${e.response?.data}');
      handler.next(e);
    },
  ));

  return dio;
}
