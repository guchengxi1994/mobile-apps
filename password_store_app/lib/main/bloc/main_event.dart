part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class DataChanged extends MainEvent {
  final int index;
  final UserData userData;
  const DataChanged({required this.index, required this.userData});
}

class DataFetched extends MainEvent {}
