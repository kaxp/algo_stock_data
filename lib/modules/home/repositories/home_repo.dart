import 'package:algo_test/modules/home/models/contracts_response.dart';
import 'package:algo_test/modules/home/models/option_chain_response.dart';
import 'package:algo_test/networking/retrofit/home_api_client.dart';

class HomeRepo {
  final HomeApiClient _homeApiClient;

  HomeRepo({required HomeApiClient homeApiClient})
      : _homeApiClient = homeApiClient;

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
}
