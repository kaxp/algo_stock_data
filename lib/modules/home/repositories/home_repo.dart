import 'package:algo_test/modules/home/models/contracts_response.dart';
import 'package:algo_test/modules/home/models/option_chain_response.dart';
import 'package:algo_test/modules/home/models/options_websocket_response.dart';
import 'package:algo_test/networking/constants/network_constants.dart';
import 'package:algo_test/networking/retrofit/home_api_client.dart';
import 'package:algo_test/networking/web_socket_client.dart';

class HomeRepo {
  final HomeApiClient _homeApiClient;
  final WebSocketClient<OptionsWebSocketResponse> _webSocketClient;

  HomeRepo({
    required HomeApiClient homeApiClient,
    required WebSocketClient<OptionsWebSocketResponse> webSocketClient,
  })  : _homeApiClient = homeApiClient,
        _webSocketClient = webSocketClient;

  Future<ContractsResponse> getContracts(
      {required String underlyingValue}) async {
    return _homeApiClient.getContracts(
      underlyingValue: underlyingValue,
    );
  }

  Future<OptionChainResponse> getOptionChains(
      {required String underlyingValue}) async {
    return _homeApiClient.getOptionChainWithLTP(
      underlyingValue: underlyingValue,
    );
  }

  Future<void> connectToOptionsWebSocket() async {
    await _webSocketClient.connect(
      socketUrl: NetworkConstants.optionsWebSocketUrl,
    );
  }

  Future<void> sendMessageToOptionsWebSocket(
      Map<String, dynamic> message) async {
    await _webSocketClient.sendMessage(message);
  }

  Future<void> closeOptionsWebSocket() async {
    await _webSocketClient.close();
  }

  // Expose the WebSocket message stream to Bloc
  Stream<OptionsWebSocketResponse?> get webSocketMessages =>
      _webSocketClient.messageStream;
}
