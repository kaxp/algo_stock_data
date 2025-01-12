import 'package:algo_test/modules/home/models/option_chain_response.dart';
import 'package:algo_test/networking/constants/network_constants.dart';
import 'package:algo_test/networking/models/app_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:retrofit/retrofit.dart';

part 'home_api_client.g.dart';

@RestApi()
abstract class HomeApiClient {
  factory HomeApiClient.withDefaultDio({String? baseUrl}) {
    return HomeApiClient(
      Modular.get<AppDio>().noAuthDio,
      baseUrl: NetworkConstants.baseUrl,
    );
  }

  factory HomeApiClient(Dio dio, {String? baseUrl}) {
    return _HomeApiClient(
      dio,
      baseUrl: NetworkConstants.baseUrl,
    );
  }

  // TODO(kapil): Update return type in follow UP PRs
  @GET('/contracts')
  Future<dynamic> getContracts({
    @Query('underlying') required String underlyingValue,
  });

  @GET('/option-chain-with-ltp')
  Future<OptionChainResponse> getOptionChain({
    @Query('underlying') required String underlyingValue,
  });
}
