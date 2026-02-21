import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config/api_config.dart';
import '../utils/logger.dart';

// Provider exposed for features to listen to
final webSocketEventsProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final service = ref.watch(webSocketServiceProvider);
  return service.events;
});

final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  return WebSocketService();
});

class WebSocketService {
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  String? _lastToken;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  WebSocketService();

  void connect(String token) {
    if (_channel != null) {
      if (_lastToken == token) return; // Already connected with same token
      disconnect(); // Reconnect if token changed
    }
    _lastToken = token;

    try {
      final wsUrl =
          "${ApiConfig.baseUrl.replaceFirst('http', 'ws')}/ws?token=$token";
      Logger.info("WS: Connecting to $wsUrl");

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _channel!.stream.listen(
        (message) {
          try {
            final data = jsonDecode(message);
            _handleMessage(data);
          } catch (e) {
            Logger.error("WS Error: Could not parse message $message");
          }
        },
        onError: (error) {
          Logger.error("WS Error: $error");
          _scheduleReconnect();
        },
        onDone: () {
          Logger.info("WS Closed");
          _scheduleReconnect();
        },
      );
    } catch (e) {
      Logger.error("WS Connection Failed: $e");
      _scheduleReconnect();
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _reconnectTimer?.cancel();
    // Don't clear lastToken if we might want to reconnect manually, but here we disconnect explicitly
    // So usually user logged out.
    _lastToken = null;
    Logger.info("WS: Disconnected");
  }

  void _scheduleReconnect() {
    if (_reconnectTimer?.isActive ?? false) return;
    if (_lastToken == null) {
      return; // Don't reconnect if explicitly disconnected/logged out
    }

    Logger.info("WS: Scheduling reconnect in 5s...");
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      _channel = null;
      if (_lastToken != null) {
        connect(_lastToken!);
      }
    });
  }

  void _handleMessage(Map<String, dynamic> message) {
    Logger.debug("WS Msg: $message");
    _controller.add(message);
  }

  Stream<Map<String, dynamic>> get events => _controller.stream;
}
