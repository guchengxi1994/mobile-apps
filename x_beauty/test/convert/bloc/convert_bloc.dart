import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

part 'convert_event.dart';
part 'convert_state.dart';

class ConvertBloc extends Bloc<ConvertEvent, ConvertState> {
  ConvertBloc() : super(ConvertState());
  final platform = MethodChannel("face.convert");
  @override
  Stream<ConvertState> mapEventToState(
    ConvertEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is ConvertChoseImgEvent) {
      yield await _chooseImgPath(state, event);
    }

    if (event is ConvertChangingEvent) {
      yield await _changeImg(state, event);
    }
  }

  @override
  Stream<Transition<ConvertEvent, ConvertState>> transformEvents(
    Stream<ConvertEvent> events,
    TransitionFunction<ConvertEvent, ConvertState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  Future<ConvertState> _chooseImgPath(
      ConvertState state, ConvertChoseImgEvent event) async {
    return state.copyWith(
        ConvertStatus.changed, event.chosenImgPath, "", false);
  }

  Future<ConvertState> _changeImg(
      ConvertState state, ConvertChangingEvent event) async {
    Map<String, Object> map = {"filename": event.filePath, "type": event.type};
    if (event.filePath != null || event.filePath != "") {
      dynamic resultValue = await platform.invokeMethod("convert", map);

      if (resultValue.runtimeType == String) {
        return state.copyWith(
            ConvertStatus.changed, state.originImgPath, resultValue, false);
      } else {
        return state.copyWith(
            ConvertStatus.changed, state.originImgPath, "", false);
      }
    } else {
      return state.copyWith(
          ConvertStatus.changed, state.originImgPath, "", false);
    }
  }
}
