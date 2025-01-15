import 'package:algo_test/modules/home/models/contracts_response.dart';
import 'package:algo_test/modules/home/models/option_chain_response.dart';
import 'package:algo_test/modules/home/repositories/home_repo.dart';
import 'package:algo_test/utils/dio_error_extension.dart';
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
  late Map<String, ContractOptionData> validTokenCache = {};

  /// [getValidContracts] fetches all the valid contracts
  /// for specified underlying value(e.g. 'BANKNIFTY) and
  /// populates the [validTokenCache] for quick token lookups.
  Future<void> getValidContracts() async {
    try {
      emit(HomeLoading());

      final response = await _homeRepo.getContracts(
        underlyingValue: underlyingValue,
      );

      if (response.contracts.contractOptions.isNotEmpty) {
        // Extract and store the cache only
        validTokenCache = response.tokenCache;
      }

      getOptionChainsWithLtp();
    } on DioException catch (error) {
      emit(HomeError(
        errorMessage: error.errorMessage(),
        optionsData: state.optionsData,
        expiryDates: state.expiryDates,
        currentExpiryDate: state.currentExpiryDate,
      ));
    }
  }

  /// [getOptionChainsWithLtp] fetches option-chain
  /// with TLP for specified underlying value
  Future<void> getOptionChainsWithLtp() async {
    try {
      if (state is! HomeLoading) {
        emit(HomeLoading());
      }

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

        if (validTokenCache.isNotEmpty) {
          connectToOptionsWebSocket();
        }
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

  /// Establishes a WebSocket connection and processes live LTP data.
  ///
  /// This method performs the following steps:
  /// 1. Subscribes to the WebSocket with the required parameters, including the current expiry date.
  /// 2. Listens for incoming messages containing a list of LTP data.
  /// 3. For each LTP item:
  ///     a. Checks if the token exists in the [validTokenCache], allowing O(1) lookups for associated contract data.
  ///     b. If a matching token is found, identifies the corresponding option from the current expiry's option chain.
  ///     c. Updates the `putClose` or `callClose` value for the matched option based on the option type (`PE` or `CE`).
  /// 4. Emits a new state with updated options data using `copyWith`, ensuring immutability and triggering UI updates.
  ///
  /// Notes:
  /// - The [validTokenCache] is a precomputed map linking tokens to their contract data.
  /// - Each update creates a new instance of `HomeLoaded` to maintain state consistency and signal UI changes.
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
            message?.ltp?.forEach((ltpMessage) {
              final token = ltpMessage.token;

              // Check if the token exists in the validTokenCache
              if (validTokenCache.containsKey(token)) {
                final contractOptionData = validTokenCache[token];

                if (contractOptionData != null) {
                  // Find the matching option based on the strike value
                  final matchingOption = state
                      .optionsData[state.currentExpiryDate]?.options
                      .firstWhere(
                    (option) => option.strike == contractOptionData.strike,
                    orElse: () => Option(strike: 0.0),
                  );

                  if (matchingOption != null) {
                    // Update the option's put or call value
                    if (contractOptionData.optionType == "PE") {
                      matchingOption.putClose = ltpMessage.ltp;
                    } else {
                      matchingOption.callClose = ltpMessage.ltp;
                    }

                    // Update the state with the modified options data
                    final updatedOptionsData =
                        Map<String, OptionData>.from(state.optionsData);

                    final updatedOptionsList = List<Option>.from(
                        updatedOptionsData[state.currentExpiryDate]?.options ??
                            []);
                    final index = updatedOptionsList.indexOf(matchingOption);

                    // Check if the matching option exists in the updatedOptionsList
                    // index == -1, when matchingOption is not found in the updatedOptionsList
                    if (index != -1) {
                      updatedOptionsList[index] = matchingOption;
                      updatedOptionsData[state.currentExpiryDate] =
                          OptionData(options: updatedOptionsList);
                    }

                    emit(HomeLoaded(
                      optionsData: updatedOptionsData,
                      expiryDates: state.expiryDates,
                      currentExpiryDate: state.currentExpiryDate,
                    ));
                  }
                }
              }
            });
          } else if (message?.errorMessage != null) {
            emit(HomeOptionsSocketError(
              errorMessage: message?.errorMessage ?? '',
              optionsData: state.optionsData,
              expiryDates: state.expiryDates,
              currentExpiryDate: state.currentExpiryDate,
            ));
          } else {
            sendMessageToOptionsWebSocket(socketMessage);
          }
        },
      );
    } catch (e) {
      emit(HomeOptionsSocketError(
        errorMessage: 'Failed to connect to WebSocket: $e',
        optionsData: state.optionsData,
        expiryDates: state.expiryDates,
        currentExpiryDate: state.currentExpiryDate,
      ));
    }
  }

  // Send a message to WebSocket
  Future<void> sendMessageToOptionsWebSocket(
      Map<String, dynamic> message) async {
    try {
      await _homeRepo.sendMessageToOptionsWebSocket(message);
    } catch (e) {
      emit(HomeOptionsSocketError(
        errorMessage: 'Error sending WebSocket message: $e',
        optionsData: state.optionsData,
        expiryDates: state.expiryDates,
        currentExpiryDate: state.currentExpiryDate,
      ));
    }
  }

  // Close the WebSocket connection
  Future<void> closeOptionsWebSocket() async {
    await _homeRepo.closeOptionsWebSocket();
  }

  void onFilterChange(String expiry) async {
    final socketMessage = {
      "msg": {
        "type": "subscribe",
        "datatypes": ["ltp"],
        "underlyings": [
          {
            "underlying": "BANKNIFTY",
            "cash": true,
            "options": [(expiry)]
          }
        ]
      }
    };
    await sendMessageToOptionsWebSocket(socketMessage);

    emit(HomeLoaded(
      optionsData: state.optionsData,
      expiryDates: state.expiryDates,
      currentExpiryDate: expiry,
    ));
  }
}
