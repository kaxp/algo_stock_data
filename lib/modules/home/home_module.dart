import 'package:algo_test/modules/app/base_app_module.dart';
import 'package:algo_test/modules/home/blocs/home_bloc.dart';
import 'package:algo_test/modules/home/pages/home_page.dart';
import 'package:algo_test/modules/home/repositories/home_repo.dart';
import 'package:algo_test/networking/retrofit/home_api_client.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends BaseAppModule {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton<HomeRepo>(
          (i) => HomeRepo(homeApiClient: HomeApiClient.withDefaultDio()),
        ),
        Bind.factory<HomeBloc>(
          (i) => HomeBloc(homeRepo: i.get<HomeRepo>()),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          HomeRoute.homePageRoute,
          child: (context, args) => const HomePage(),
        ),
      ];
}

class HomeRoute {
  static const String homePageRoute = '/';
}
