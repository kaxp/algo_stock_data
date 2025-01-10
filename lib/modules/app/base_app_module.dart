import 'package:algo_test/networking/http_client.dart';
import 'package:algo_test/networking/models/app_dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// [BaseAppModule] is the primary module that will hold all the common
/// dependencies
class BaseAppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind<AppDio>(
          (i) => AppDio(
            noAuthDio: httpClient(),
          ),
        ),
      ];

  @override
  List<ModularRoute> get routes => [];
}

class BaseAppModuleRoutes {
  static const String homePage = '/';
}
