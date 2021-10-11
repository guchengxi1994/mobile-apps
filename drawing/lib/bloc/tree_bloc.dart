import 'package:bloc/bloc.dart';
import 'package:drawing/common.dart';
import 'package:drawing/models/models.dart';
import 'package:drawing/widgets/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
    List paintObjects = generatePaint(l, event.level);
    return emit(state.copyWith(TreePaintStatus.initial, l, 0, paintObjects));
  }

  Future<void> _onPaint(TreePaintEvent event, Emitter<TreeState> emit) async {
    int currentIndex = state.currentIndex + 1;
    if (currentIndex < state.paintObjects.length) {
      return emit(state.copyWith(TreePaintStatus.initial, state.objects,
          currentIndex, state.paintObjects));
    }
  }
}

List generatePaint(List l, int level) {
  List res = [];
  if (level > 0) {
    Offset rootOffset =
        Offset(0.47 * CommonUtil.screenW(), 0.9 * CommonUtil.screenH());

    var root = TreeRoot(offset: rootOffset);

    var layer0 = l[1]; //RootModel

    debugPrint('root :: ' + root.endOffset.toString());

    res.add(root);

    for (int i = 0; i < layer0.childIds.length; i++) {
      // res.add()
      var treeStick = TreeStick(
        offset: root.endOffset,
        isEnd: level == 1,
        id: layer0.childIds[i],
      );
      debugPrint('stick :: ' + treeStick.endOffset.toString());
      res.add(treeStick);
    }
    if (level == 1) {
      for (int i = 0; i < layer0.childIds.length; i++) {
        TreeStick _stick = res.firstWhere((element) {
          if (element.runtimeType == TreeStick &&
              element.id == layer0.childIds[i]) {
            return true;
          }
          return false;
        });
        var leaf = TreeLeaf(offset: _stick.endOffset, id: layer0.childIds[i]);

        res.add(leaf);
      }
    }
  }
  debugPrint('res length ::' + res.length.toString());
  return res;
}
