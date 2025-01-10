import 'package:algo_test/config/flavor_config.dart';
import 'package:algo_test/networking/constants/network_constants.dart';
import 'main_base.dart';

void main() async {
  runMain(
    configInit: () => FlavorConfig(
      flavor: Flavor.staging,
      values: FlavorValues(
        baseUrl: NetworkConstants.stagingBaseUrl,
      ),
    ),
    dumpErrorToConsole: true,
  );
}
