import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:algo_test/constants/app_strings.dart';
import 'package:algo_test/utils/log.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// TODO(kapil): Refactor the socket client types when integrating API
class WebSocketClient<T> {
  WebSocketChannel? _channel;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;
  final Duration _initialDelay = const Duration(seconds: 2);
  late String url;

  // Stream controller to emit raw messages received from the server
  final StreamController<T> _controller = StreamController<T>.broadcast();

  Future<void> connect({required String socketUrl}) async {
    url = socketUrl;
    _channel = WebSocketChannel.connect(Uri.parse(socketUrl));
    listenForMessages();

    // We can add Heartbeat/Ping-Pong Mechanism here if required
  }

  Future<void> sendMessage(Map<String, dynamic> message) async {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(message));
    }
  }

  void listenForMessages() {
    _channel!.stream.listen(
      (message) {
        _controller.add(message);
      },
      onError: _handleError,
      onDone: _handleClosed,
    );
  }

  void _handleError(Object error) {
    Log.error("${AppStrings.error}: $error");

    // Start reconnection process on error
    _reconnect();
  }

  void _handleClosed() {
    Log.debug(AppStrings.webSocketClosed);

    // Start reconnection process when WebSocket is closed
    _reconnect();
  }

  Future<void> _reconnect() async {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      Log.error(AppStrings.maxReconnectionAttemptsReached);
      return;
    }

    _reconnectAttempts++;

    // Calculating delay with exponential backoff
    final delay = _initialDelay * pow(2, _reconnectAttempts - 1);

    Log.warning("${AppStrings.attemptingToReconnectIn} $delay...");
    await Future.delayed(delay);

    try {
      await connect(socketUrl: url);
      Log.debug(AppStrings.reconnectionSuccessful);

      // Reset attempts after successful reconnect
      _reconnectAttempts = 0;
    } catch (e) {
      Log.error("${AppStrings.reconnectingAttemptFailed}: $e");

      // Retry reconnection if failed
      _reconnect();
    }
  }

  Future<void> close() async {
    await _channel?.sink.close();
    await _controller.close();
  }

  // Expose the stream to external classes
  Stream<T> get messageStream => _controller.stream;
}
