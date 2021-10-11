part of 'tree_bloc.dart';

enum TreePaintStatus { initial, painting, finish }

class TreeState extends Equatable {
  final int currentIndex;
  final List objects;
  final TreePaintStatus status;
  final List paintObjects;

  const TreeState(
      {this.status = TreePaintStatus.initial,
      this.currentIndex = 0,
      this.objects = const [],
      this.paintObjects = const []});

  @override
  List<Object> get props => [status, objects, currentIndex, paintObjects];

  TreeState copyWith(TreePaintStatus? status, List? objects, int? currentIndex,
      List? paintObjects) {
    return TreeState(
        status: status ?? this.status,
        objects: objects ?? this.objects,
        currentIndex: currentIndex ?? this.currentIndex,
        paintObjects: paintObjects ?? this.paintObjects);
  }
}
