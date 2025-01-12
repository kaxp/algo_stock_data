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

  /// [getOptionChainsWithLtp] fetches option-chain
  /// with TLP for specified underlying value
  Future<void> getOptionChainsWithLtp() async {
    try {
      emit(HomeLoading());

      final response = await _homeRepo.getOptionChains(
        underlyingValue: underlyingValue,
      );

      emit(response.options.isNotEmpty
          ? HomeLoaded(data: response)
          : HomeEmpty());
    } on DioException catch (error) {
      emit(HomeError(error.errorMessage()));
    }
  }
}
