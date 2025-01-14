part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState({
    this.optionsData = const {},
    this.expiryDates = const [],
    this.currentExpiryDate = '',
  });

  final Map<String, OptionData> optionsData;
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
    required Map<String, OptionData> optionsData,
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
    required Map<String, OptionData> optionsData,
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

class HomeOptionsSocketMessageReceived extends HomeState {
  const HomeOptionsSocketMessageReceived({
    required this.socketMessage,
  });

  final OptionsWebSocketResponse? socketMessage;
}
