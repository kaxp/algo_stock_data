import 'dart:async';

import 'package:algo_test/config/flavor_config.dart';
import 'package:algo_test/config/themes/app_theme.dart';
import 'package:algo_test/constants/widget_keys.dart';
import 'package:algo_test/modules/app/base_app_module.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

void runMain({
  required FlavorConfig Function() configInit,
  required bool dumpErrorToConsole,
}) async {
  runZonedGuarded<Future<void>>(() async {
    await _init(configInit: configInit);

    runApp(
      ModularApp(
        module: BaseAppModule(),
        child: EasyLocalization(
          supportedLocales: const [Locale('en')],
          path: 'i18n',
          fallbackLocale: const Locale('en'),
          child: const RootApp(),
        ),
      ),
    );
  }, (error, stack) {
    final details = FlutterErrorDetails(exception: error, stack: stack);
    if (dumpErrorToConsole) {
      FlutterError.dumpErrorToConsole(details);
    }
  });
}

/// A Helper method that is used for initialising app services like
/// firebase, remote config, shared preferences, or other 3rd party SDK
/// dependencies.
///
/// All the services that needs to be initialised at the start of the app
/// will be added here.
Future<void> _init({
  required FlavorConfig Function() configInit,
}) async {
  // initialize widget binding
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise localization
  await EasyLocalization.ensureInitialized();

  // init flavors specific values
  configInit();
}

/// [RootApp] is the root widget of application
class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp.router(
      title: 'AlgoTest',
      theme: AppTheme.defaultTheme,
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: WidgetKeys.rootScaffoldMessengerKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
