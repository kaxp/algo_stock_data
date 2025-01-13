import 'package:algo_test/config/flavor_config.dart';

class NetworkConstants {
  static String prodBaseUrl = 'https://prices.algotest.xyz';

  static String stagingBaseUrl = 'https://prices.algotest.xyz';

  static String devBaseUrl = 'https://prices.algotest.xyz';

  static String mockServerUrl = 'https://prices.algotest.xyz';

  static final String baseUrl = FlavorConfig.instance!.values.baseUrl;
}
