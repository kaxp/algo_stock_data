import 'package:algo_test/config/flavor_config.dart';
import 'main_base.dart';

void main() async {
  runMain(
    configInit: () => FlavorConfig(
      flavor: Flavor.staging,
      values: const FlavorValues(
        // TODO(kapil): Add url's
        baseUrl: '',
        clientId: '',
      ),
    ),
    dumpErrorToConsole: true,
  );
}
