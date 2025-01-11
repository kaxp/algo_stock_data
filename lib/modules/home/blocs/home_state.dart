part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  // TODO(kapil): Update with actual data type
  final dynamic data;

  HomeLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class HomeError extends HomeState {
  final String errorMessage;

  HomeError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
