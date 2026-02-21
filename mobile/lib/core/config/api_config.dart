import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  // CONFIGURATION
  // ---------------------------------------------------------------------------
  // 1. PRODUCTION URL - Used when app is built in release mode
  static const String productionUrl = 'https://api.devapp.com';

  // 2. ADB REVERSE URL (Physical Device via USB)
  //    Most reliable method - works over USB without WiFi
  //    Run: adb reverse tcp:8000 tcp:8000
  static const String adbReverseUrl = 'http://localhost:8000';

  // 3. LOCAL LAN URL (Physical Device via WiFi)
  //    Run `ipconfig` (Windows) to find your IPv4 address
  //    Your phone must be on the same WiFi network as your PC
  //    Ensure backend runs with `--host 0.0.0.0`
  static const String localLanIp = 'http://192.168.1.5:8000';

  // 4. EMULATOR URL - Android Emulator special address
  static const String emulatorIp = 'http://10.0.2.2:8000';
  // ---------------------------------------------------------------------------

  // Connection mode for development
  // Options: 'emulator', 'adb', 'wifi'
  // Override via: flutter run --dart-define=DEV_MODE=adb
  static const String _devMode =
      String.fromEnvironment('DEV_MODE', defaultValue: 'adb');

  static String get baseUrl {
    if (kReleaseMode) {
      return productionUrl;
    }

    // Allow direct URL override (highest priority)
    const envUrl = String.fromEnvironment('API_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }

    if (Platform.isAndroid) {
      switch (_devMode) {
        case 'emulator':
          return emulatorIp;
        case 'wifi':
          return localLanIp;
        case 'adb':
        default:
          // ADB reverse is the most reliable for physical devices
          // Run: adb reverse tcp:8000 tcp:8000
          return adbReverseUrl;
      }
    } else {
      // iOS / Desktop / Web
      return 'http://127.0.0.1:8000';
    }
  }

  /// Get WS URL derived from base URL
  static String get wsBaseUrl {
    return baseUrl.replaceFirst('http', 'ws');
  }
}
