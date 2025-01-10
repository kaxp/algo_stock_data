import 'package:algo_test/config/flavor_config.dart';
import 'package:algo_test/main_base.dart';
import 'package:algo_test/networking/constants/network_constants.dart';

void main() async {
  runMain(
    configInit: () => FlavorConfig(
      flavor: Flavor.development,
      values: FlavorValues(
        baseUrl: NetworkConstants.devBaseUrl,
      ),
    ),
    dumpErrorToConsole: true,
  );
}
