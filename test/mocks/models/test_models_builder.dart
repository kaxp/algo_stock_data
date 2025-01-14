import 'package:algo_test/modules/home/models/contracts_response.dart';
import 'package:algo_test/modules/home/models/option_chain_response.dart';
import 'package:algo_test/modules/home/models/options_websocket_response.dart';

ContractsResponse buildContractsResponseFromTemplate({
  ContractsData? contracts,
}) {
  return ContractsResponse(
    contracts: contracts!,
  );
}

OptionChainResponse buildOptionChainResponseFromTemplate({
  String candle = '',
  String underlying = '',
  Map<String, OptionData>? options,
  Map<String, double>? impliedFutures,
}) {
  return OptionChainResponse(
    candle: candle,
    underlying: underlying,
    options: options!,
    impliedFutures: impliedFutures!,
  );
}

OptionsWebSocketResponse buildOptionWebsocketResponseFromTemplate({
  List<LtpSocketData>? ltp,
  String? errorMessage,
}) {
  return OptionsWebSocketResponse(
    ltp: ltp,
    errorMessage: errorMessage,
  );
}
