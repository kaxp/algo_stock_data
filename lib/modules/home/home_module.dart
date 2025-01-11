import 'package:algo_test/modules/app/base_app_module.dart';
import 'package:algo_test/modules/home/blocs/home_bloc.dart';
import 'package:algo_test/modules/home/pages/home_page.dart';
import 'package:algo_test/modules/home/repositories/home_repo.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends BaseAppModule {
  @override
  List<Bind> get binds => [
        Bind<HomeRepo>((_) => HomeRepo()),
        Bind<HomeBloc>((_) => HomeBloc()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (context, args) => const HomePage(),
        ),
      ];
}

class HomeRoute {
  static const String moduleRoute = '/';
}
