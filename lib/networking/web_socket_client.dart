import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:algo_test/constants/app_strings.dart';
import 'package:algo_test/utils/log.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient<T> {
  WebSocketClient({this.fromJson});

  WebSocketChannel? _channel;
  bool _isConnected = false;
  String _url = '';

  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 20;
  final Duration _initialDelay = const Duration(seconds: 2);

  /// Stream controller to emit raw messages received from the server
  final StreamController<T> _controller = StreamController<T>.broadcast();

  /// A deserialization function to convert raw JSON to T
  final T Function(String)? fromJson;

  /// Connect to the WebSocket server
  Future<void> connect({required String socketUrl}) async {
    _url = socketUrl;

    _channel = WebSocketChannel.connect(Uri.parse(socketUrl));

    listenForMessages();
    Log.debug("WebSocket connecting to $socketUrl");

    // We can add Heartbeat/Ping-Pong Mechanism here if required
  }

  /// Send a message through the WebSocket
  Future<void> sendMessage(Map<String, dynamic> message) async {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(message));
    }
  }

  /// Listen for incoming messages and connection events
  void listenForMessages() {
    _channel?.stream.listen(
      (message) => _handleIncomingMessage(message),
      onError: _handleError,
      onDone: _handleClosed,
    );
  }

  /// Handle reconnection with exponential backoff
  Future<void> _reconnect() async {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      Log.error(AppStrings.maxReconnectionAttemptsReached);
      return;
    }

    _reconnectAttempts++;
    final delay = _initialDelay * pow(2, _reconnectAttempts - 1);
    Log.warning("Attempting to reconnect in $delay...");

    await Future.delayed(delay);

    try {
      await connect(socketUrl: _url);
      if (_isConnected) {
        Log.debug(AppStrings.reconnectionSuccessful);
        _reconnectAttempts = 0;
      }
    } catch (e) {
      Log.error("Reconnection attempt failed: $e");
      _reconnect();
    }
  }

  /// Close the WebSocket
  Future<void> close() async {
    await _channel?.sink.close();
    await _controller.close();
  }

  void _handleIncomingMessage(dynamic message) {
    if (!_isConnected) {
      _isConnected = true;
      Log.debug("WebSocket connection established.");
    }

    try {
      final data = fromJson!(message);
      _controller.add(data);
    } catch (e) {
      Log.error("Failed to parse incoming message: $e");
    }
  }

  void _handleError(Object error) {
    _isConnected = false;
    Log.error("WebSocket error: $error");

    if (error is WebSocketChannelException &&
        error.toString().contains('SocketException: Failed host lookup')) {
      _emitErrorToStream(AppStrings.noInternetAvailable);
    }

    _reconnect();
  }

  void _handleClosed() {
    _isConnected = false;
    Log.debug(AppStrings.webSocketClosed);
    _reconnect();
  }

  void _emitErrorToStream(String errorMessage) {
    try {
      final errorData = jsonEncode({"errorMessage": errorMessage});
      final data = fromJson!(errorData);
      _controller.add(data);
    } catch (e) {
      Log.error("Failed to emit error message to stream: $e");
    }
  }

  /// Expose the message stream to external listeners
  Stream<T> get messageStream => _controller.stream;

  /// Check WebSocket connection status
  bool get isConnected => _isConnected;
}
