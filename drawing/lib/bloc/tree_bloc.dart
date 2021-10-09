import 'package:bloc/bloc.dart';
import 'package:drawing/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'tree_event.dart';
part 'tree_state.dart';

const _duration = Duration(microseconds: 50);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class TreeBloc extends Bloc<TreeEvent, TreeState> {
  TreeBloc() : super(const TreeState()) {
    on<TreeEvent>((event, emit) {});
    on<TreeInitialEvent>(_onInitial, transformer: throttleDroppable(_duration));
    on<TreePaintEvent>(_onPaint, transformer: throttleDroppable(_duration));
  }

  Future<void> _onInitial(
      TreeInitialEvent event, Emitter<TreeState> emit) async {
    TreeModel treeModel = TreeModel(levels: event.level, stickNumber: 2);
    List l = treeModel.generateTreeModel();
    return emit(state.copyWith(TreePaintStatus.initial, l, 0));
  }

  Future<void> _onPaint(TreePaintEvent event, Emitter<TreeState> emit) async {
    int currentIndex = state.currentIndex + 1;
    if (currentIndex < state.objects.length) {
      return emit(
          state.copyWith(TreePaintStatus.initial, state.objects, currentIndex));
    }
  }
}
