part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState({
    this.optionsData,
    this.expiryDates = const [],
    this.currentExpiryDate = '',
  });

  final OptionChainResponse? optionsData;
  final List<String> expiryDates;
  final String currentExpiryDate;

  @override
  List<Object?> get props => [
        optionsData,
        expiryDates,
        currentExpiryDate,
      ];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeEmpty extends HomeState {}

class HomeLoaded extends HomeState {
  const HomeLoaded({
    required OptionChainResponse optionsData,
    required List<String> expiryDates,
    required String currentExpiryDate,
    int? timeStamp,
  }) : super(
          optionsData: optionsData,
          expiryDates: expiryDates,
          currentExpiryDate: currentExpiryDate,
        );
}

class HomeError extends HomeState {
  const HomeError({
    required this.errorMessage,
    required OptionChainResponse optionsData,
    required List<String> expiryDates,
    required String currentExpiryDate,
  }) : super(
          optionsData: optionsData,
          expiryDates: expiryDates,
          currentExpiryDate: currentExpiryDate,
        );

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
