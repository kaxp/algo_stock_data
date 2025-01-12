import 'package:algo_test/modules/home/models/option_chain_response.dart';
import 'package:algo_test/networking/retrofit/home_api_client.dart';

class HomeRepo {
  final HomeApiClient _homeApiClient;

  /// Constructor for dependency injection.
  HomeRepo({required HomeApiClient homeApiClient})
      : _homeApiClient = homeApiClient;

  Future<OptionChainResponse> getOptionChains(
      {required String underlyingValue}) async {
    return _homeApiClient.getOptionChain(underlyingValue: underlyingValue);
  }
}
