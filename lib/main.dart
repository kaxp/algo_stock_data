import 'package:algo_test/config/flavor_config.dart';
import 'package:flutter/foundation.dart';
import 'main_base.dart';

void main() async {
  // disable debug print on production release mode
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  runMain(
    configInit: () => FlavorConfig(
      flavor: Flavor.production,
      values: const FlavorValues(
        // TODO(kapil): Add url's
        baseUrl: '',
        clientId: '',
      ),
    ),
    dumpErrorToConsole: false,
  );
}
