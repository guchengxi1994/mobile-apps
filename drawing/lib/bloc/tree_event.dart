part of 'tree_bloc.dart';

abstract class TreeEvent extends Equatable {
  const TreeEvent();

  @override
  List<Object> get props => [];
}

class TreeInitialEvent extends TreeEvent {
  final int level;
  const TreeInitialEvent({required this.level});
}

class TreePaintEvent extends TreeEvent {}
