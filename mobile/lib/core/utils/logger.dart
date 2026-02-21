import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class Logger {
  static void debug(String message, {String name = 'App'}) {
    if (kDebugMode) {
      developer.log(message, name: name, level: 0);
    }
  }

  static void info(String message, {String name = 'App'}) {
    if (kDebugMode) {
      developer.log(message, name: name, level: 500);
    }
  }

  static void error(String message,
      {String name = 'App', Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      developer.log(message,
          name: name, error: error, stackTrace: stackTrace, level: 1000);
    }
  }
}
