part of 'tree_bloc.dart';

enum TreePaintStatus { initial, painting, finish }

class TreeState extends Equatable {
  final int currentIndex;
  final List objects;
  final TreePaintStatus status;

  const TreeState(
      {this.status = TreePaintStatus.initial,
      this.currentIndex = 0,
      this.objects = const []});

  @override
  List<Object> get props => [status, objects, currentIndex];

  TreeState copyWith(
      TreePaintStatus? status, List? objects, int? currentIndex) {
    return TreeState(
        status: status ?? this.status,
        objects: objects ?? this.objects,
        currentIndex: currentIndex ?? this.currentIndex);
  }
}
