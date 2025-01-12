part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeEmpty extends HomeState {}

class HomeLoaded extends HomeState {
  final OptionChainResponse data;

  HomeLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

class HomeError extends HomeState {
  final String errorMessage;

  HomeError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
