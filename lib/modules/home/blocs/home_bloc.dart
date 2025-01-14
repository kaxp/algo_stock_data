import 'package:algo_test/modules/home/models/contracts_response.dart';
import 'package:algo_test/modules/home/models/option_chain_response.dart';
import 'package:algo_test/modules/home/models/options_websocket_response.dart';
import 'package:algo_test/modules/home/repositories/home_repo.dart';
import 'package:algo_test/utils/dio_error_extension.dart';
import 'package:algo_test/utils/log.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeBloc extends Cubit<HomeState> {
  final HomeRepo _homeRepo;
  final String underlyingValue;

  HomeBloc({
    required HomeRepo homeRepo,
    this.underlyingValue = 'BANKNIFTY',
  })  : _homeRepo = homeRepo,
        super(HomeInitial());

  /// [validTokenCache] is a cache for token lookups
  /// in O(1) T.C
  ///
  /// It maps `token` (String) to its corresponding
  /// `ContractOptionData` received in /contracts API.
  late final Map<String, ContractOptionData> validTokenCache;

  /// [getValidContracts] fetches all the valid contracts
  /// for specified underlying value(e.g. 'BANKNIFTY) and
  /// populates the `validTokenCache` for quick token lookups.
  ///
  /// It's an background API call which will not affect the
  /// UI/UX of our app.
  Future<void> getValidContracts() async {
    try {
      final response = await _homeRepo.getContracts(
        underlyingValue: underlyingValue,
      );

      if (response.contracts.contractOptions.isNotEmpty) {
        // Extract and store the cache only
        validTokenCache = response.tokenCache;
      } else {
        // TODO(kapil): Handle empty state
      }
    } on DioException catch (error) {
      Log.error(error.errorMessage());
      // TODO(kapil): Handle error state
    }
  }

  /// [getOptionChainsWithLtp] fetches option-chain
  /// with TLP for specified underlying value
  Future<void> getOptionChainsWithLtp() async {
    try {
      emit(HomeLoading());

      final response = await _homeRepo.getOptionChains(
        underlyingValue: underlyingValue,
      );

      if (response.options.isNotEmpty) {
        final expiryDates = response.options.keys.toList();

        emit(HomeLoaded(
          optionsData: response.options,
          expiryDates: expiryDates,
          currentExpiryDate: expiryDates.first,
        ));

        connectToOptionsWebSocket();
      } else {
        emit(HomeEmpty());
      }
    } on DioException catch (error) {
      emit(HomeError(
        errorMessage: error.errorMessage(),
        optionsData: state.optionsData,
        expiryDates: state.expiryDates,
        currentExpiryDate: state.currentExpiryDate,
      ));
    }
  }

  // TODO(kapil): Handle error states for the socket
  // Connect to WebSocket and listen for messages
  Future<void> connectToOptionsWebSocket() async {
    try {
      await _homeRepo.connectToOptionsWebSocket();

      final socketMessage = {
        "msg": {
          "type": "subscribe",
          "datatypes": ["ltp"],
          "underlyings": [
            {
              "underlying": "BANKNIFTY",
              "cash": true,
              "options": [(state.currentExpiryDate)]
            }
          ]
        }
      };
      await sendMessageToOptionsWebSocket(socketMessage);

      // Listen to WebSocket messages and process them in the Bloc
      _homeRepo.webSocketMessages.listen(
        (message) {
          if (message?.ltp != null) {
            // TODO(kapil): Process the data and emit state
            // emit(HomeOptionsSocketMessageReceived(socketMessage: message));
          }
        },
        onError: (error) {
          Log.error("WebSocket Error: $error");
          // emit(HomeError("WebSocket Error: $error"));
        },
        onDone: () {
          Log.debug("WebSocket connection closed");
        },
      );
    } catch (e) {
      Log.error("Error connecting to WebSocket: $e");
      // emit(HomeError("Failed to connect to WebSocket: $e"));
    }
  }

  // Send a message to WebSocket
  Future<void> sendMessageToOptionsWebSocket(
      Map<String, dynamic> message) async {
    try {
      await _homeRepo.sendMessageToOptionsWebSocket(message);
    } catch (e) {
      Log.error("Error sending WebSocket message: $e");
      // emit(HomeError("Failed to send message: $e"));
    }
  }

  // Close the WebSocket connection
  Future<void> closeOptionsWebSocket() async {
    await _homeRepo.closeOptionsWebSocket();
  }

  void onFilterChange(String expiry) {
    emit(HomeLoaded(
      optionsData: state.optionsData,
      expiryDates: state.expiryDates,
      currentExpiryDate: expiry,
    ));
  }
}
