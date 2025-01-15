// ignore_for_file: unused_element

import 'package:algo_test/config/flavor_config.dart';
import 'package:algo_test/modules/home/blocs/home_bloc.dart';
import 'package:algo_test/modules/home/home_module.dart';
import 'package:algo_test/modules/home/models/contracts_response.dart';
import 'package:algo_test/modules/home/repositories/home_repo.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:algo_test/modules/home/models/option_chain_response.dart';
import 'package:modular_test/modular_test.dart';

import '../../../mocks/bloc/mock_blocs.mocks.dart';
import '../../../mocks/models/test_models_builder.dart';
import '../../../mocks/repositories/mock_repositories.mocks.dart';
import '../../../test_utils/mock_dio_exception.dart';

ContractsResponse _defaultContractsResponse() {
  return buildContractsResponseFromTemplate(
    contracts: const ContractsData(
      contractOptions: {
        "2025-02-27": [
          ContractOptionData(
            token: 'NSE_3677',
            expiry: '2025-02-27',
            strike: 42000.0,
            optionType: 'PE',
          )
        ]
      },
    ),
  );
}

OptionChainResponse _defaultOptionChainResponse() {
  return buildOptionChainResponseFromTemplate(
    candle: '',
    underlying: '',
    impliedFutures: {},
    options: {
      '2025-01-01': OptionData(options: [Option(strike: 10000.0)]),
    },
  );
}

OptionChainResponse _defaultOptionChainEmptyResponse() {
  return buildOptionChainResponseFromTemplate(
    candle: '',
    underlying: '',
    impliedFutures: {},
    options: {},
  );
}

// TODO(kapil): Write remaining unit tests
void main() {
  late MockHomeRepo _mockHomeRepo;
  late MockHomeBloc _mockHomeBloc;

  setUpAll(() {
    FlavorConfig(
      flavor: Flavor.mock,
      values: const FlavorValues(
        baseUrl: '',
      ),
    );
    _mockHomeRepo = MockHomeRepo();
    _mockHomeBloc = MockHomeBloc();
  });

  setUp(() async {
    initModule(HomeModule(), replaceBinds: [
      Bind<HomeBloc>((_) => _mockHomeBloc),
      Bind<HomeRepo>((_) => _mockHomeRepo),
    ]);
  });

  group('HomeBloc Tests', () {
    test('''Given getOptionChainsWithLtp() is called
        When option chain data is successfully returned
        Then the state should be HomeLoaded''', () async {
      final bloc = HomeBloc(homeRepo: _mockHomeRepo);

      bloc.validTokenCache = {};

      when(_mockHomeRepo.getOptionChains(underlyingValue: 'BANKNIFTY'))
          .thenAnswer((_) async => _defaultOptionChainResponse());

      await bloc.getOptionChainsWithLtp();

      expect(bloc.state, isA<HomeLoaded>());
    });

    test('''Given getOptionChainsWithLtp() is called
        When option chain data is empty
        Then the state should be HomeEmpty''', () async {
      final bloc = HomeBloc(homeRepo: _mockHomeRepo);

      bloc.validTokenCache = {};

      when(_mockHomeRepo.getOptionChains(underlyingValue: 'BANKNIFTY'))
          .thenAnswer((_) async => _defaultOptionChainEmptyResponse());

      await bloc.getOptionChainsWithLtp();

      expect(bloc.state, isA<HomeEmpty>());
    });

    test('''Given getOptionChainsWithLtp() is called
        When getOptionChainsWithLtp method throw DioException
        Then the state should be HomeError''', () async {
      final bloc = HomeBloc(homeRepo: _mockHomeRepo);

      bloc.validTokenCache = {};

      when(_mockHomeRepo.getOptionChains(underlyingValue: 'BANKNIFTY'))
          .thenAnswer((_) async => throw MockDioException());

      await bloc.getOptionChainsWithLtp();

      expect(bloc.state, isA<HomeError>());
    });
  });
}
