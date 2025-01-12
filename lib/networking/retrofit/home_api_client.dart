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
  @GET('/contracts?underlying=BANKNIFTY')
  Future<dynamic> getContracts();

  // TODO(kapil): Update return type in follow UP PRs
  @GET('/option-chain-with-ltp?underlying=BANKNIFTY')
  Future<dynamic> getOptionChain();
}
