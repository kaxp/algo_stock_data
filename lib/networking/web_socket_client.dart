import 'dart:async';
import 'dart:convert';
import 'package:algo_test/constants/app_strings.dart';
import 'package:algo_test/utils/log.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient<T> {
  WebSocketClient({this.fromJson});

  WebSocketChannel? _channel;
  bool _isConnected = false;
  String _url = '';

  bool _isReconnecting = false;

  /// Stream controller to emit raw messages received from the server
  final StreamController<T> _controller = StreamController<T>.broadcast();

  /// A deserialization function to convert raw JSON to T
  final T Function(String)? fromJson;

  /// Connect to the WebSocket server
  Future<void> connect({required String socketUrl}) async {
    _url = socketUrl;

    _channel = WebSocketChannel.connect(Uri.parse(socketUrl));

    listenForMessages();
    Log.debug("${AppStrings.webSocketConnectingTo} $socketUrl");

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

  /// Handle reconnection with 5 second delay
  Future<void> _reconnect() async {
    if (_isReconnecting) return;
    _isReconnecting = true;

    const delay = Duration(seconds: 5);
    Log.warning("${AppStrings.attemptingToReconnectIn} $delay...");

    await Future.delayed(delay);

    try {
      await connect(socketUrl: _url);
      if (_isConnected) {
        Log.debug(AppStrings.reconnectionSuccessful);
      }
    } catch (e) {
      Log.error("${AppStrings.reconnectingAttemptFailed}: $e");
      _reconnect();
    } finally {
      _isReconnecting = false; // Allow further reconnections
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
      Log.debug(AppStrings.webSocketConnectionEstablished);
    }

    try {
      final data = fromJson!(message);
      _controller.add(data);
    } catch (e) {
      Log.error("${AppStrings.failedToParseMessage} $e");
    }
  }

  void _handleError(Object error) {
    _isConnected = false;
    Log.error("${AppStrings.webSocketError} $error");

    if (error is WebSocketChannelException &&
        error.toString().contains('SocketException: Failed host lookup')) {
      final errorData =
          jsonEncode({"errorMessage": AppStrings.noInternetAvailable});
      final data = fromJson!(errorData);
      _controller.add(data);
    }

    _reconnect();
  }

  void _handleClosed() {
    _isConnected = false;
    Log.debug(AppStrings.webSocketClosed);
    _reconnect();
  }

  /// Expose the message stream to external listeners
  Stream<T> get messageStream => _controller.stream;

  /// Check WebSocket connection status
  bool get isConnected => _isConnected;
}
