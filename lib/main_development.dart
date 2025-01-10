import 'package:algo_test/config/flavor_config.dart';
import 'package:algo_test/main_base.dart';

void main() async {
  runMain(
    configInit: () => FlavorConfig(
      flavor: Flavor.development,
      values: const FlavorValues(
        // TODO(kapil): Add url's
        baseUrl: '',
        clientId: '',
      ),
    ),
    dumpErrorToConsole: true,
  );
}
