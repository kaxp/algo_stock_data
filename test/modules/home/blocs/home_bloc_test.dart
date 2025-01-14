import 'package:algo_test/config/flavor_config.dart';
import 'package:algo_test/modules/home/blocs/home_bloc.dart';
import 'package:algo_test/modules/home/home_module.dart';
import 'package:algo_test/modules/home/repositories/home_repo.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:algo_test/modules/home/models/option_chain_response.dart';
import 'package:dio/dio.dart';
import 'package:modular_test/modular_test.dart';

import '../../../mocks/bloc/mock_blocs.mocks.dart';
import '../../../mocks/repositories/mock_repositories.mocks.dart';

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
    // test('''Given getValidContracts() is called
    //     When valid contracts are returned
    //     Then the state should be HomeLoaded''', () async {
    //   final contractsResponse = ContractsResponse(
    //     contracts: Contracts(
    //       contractOptions: [ContractOption(symbol: 'BANKNIFTY')],
    //     ),
    //     tokenCache: {
    //       'BANKNIFTY': ContractOptionData(strike: 10000.0, optionType: 'CE')
    //     },
    //   );
    //   when(_mockHomeRepo.getContracts(underlyingValue: 'BANKNIFTY'))
    //       .thenAnswer((_) async => contractsResponse);

    //   await _mockHomeBloc.getValidContracts();

    //   expect(_homeBloc.state, isA<HomeLoaded>());
    // });

    test('''Given getValidContracts() is called
        When an error occurs in fetching contracts
        Then the state should be HomeError''', () async {
      when(_mockHomeRepo.getContracts(underlyingValue: 'BANKNIFTY'))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
      ));

      await _mockHomeBloc.getValidContracts();

      expect(_mockHomeBloc.state, isA<HomeError>());
    });

    test('''Given getOptionChainsWithLtp() is called
        When option chain data is successfully returned
        Then the state should be HomeLoaded''', () async {
      final optionChainResponse = OptionChainResponse(
          options: {
            '2025-01-01': OptionData(options: [Option(strike: 10000.0)]),
          },
          candle: "",
          underlying: "BANKNIFTY",
          impliedFutures: {});
      when(_mockHomeRepo.getOptionChains(underlyingValue: 'BANKNIFTY'))
          .thenAnswer((_) async => optionChainResponse);

      await _mockHomeBloc.getOptionChainsWithLtp();

      expect(_mockHomeBloc.state, isA<HomeLoaded>());
    });

    test('''Given getOptionChainsWithLtp() is called
        When an error occurs in fetching option chains
        Then the state should be HomeError''', () async {
      when(_mockHomeRepo.getOptionChains(underlyingValue: 'BANKNIFTY'))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
      ));

      await _mockHomeBloc.getOptionChainsWithLtp();

      expect(_mockHomeBloc.state, isA<HomeError>());
    });

    // test('''Given connectToOptionsWebSocket() is called
    //     When a successful WebSocket connection is made
    //     Then the state should be HomeLoaded''', () async {
    //   final socketMessage = {
    //     "msg": {
    //       "type": "subscribe",
    //       "datatypes": ["ltp"],
    //       "underlyings": [
    //         {
    //           "underlying": "BANKNIFTY",
    //           "cash": true,
    //           "options": ['2025-01-01']
    //         }
    //       ]
    //     }
    //   };

    //   when(_mockHomeRepo.connectToOptionsWebSocket()).thenAnswer((_) async {});
    //   when(_mockHomeRepo.webSocketMessages).thenAnswer((_) => Stream.value(
    //       WebSocketMessage(ltp: [LtpData(token: 'BANKNIFTY', ltp: 100.0)])));

    //   await _mockHomeBloc.connectToOptionsWebSocket();

    //   expect(_mockHomeBloc.state, isA<HomeLoaded>());
    // });

    test('''Given connectToOptionsWebSocket() is called
        When a WebSocket connection fails
        Then the state should be HomeOptionsSocketError''', () async {
      when(_mockHomeRepo.connectToOptionsWebSocket())
          .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      await _mockHomeBloc.connectToOptionsWebSocket();

      expect(_mockHomeBloc.state, isA<HomeOptionsSocketError>());
    });

    // test('''Given onFilterChange() is called
    //     When a new expiry date is selected
    //     Then the state should update with the new expiry date''', () async {
    //   await _mockHomeBloc.onFilterChange('2025-02-01');

    //   expect(_mockHomeBloc.state, isA<HomeLoaded>());
    //   expect((_mockHomeBloc.state as HomeLoaded).currentExpiryDate, '2025-02-01');
    // });
  });
}
