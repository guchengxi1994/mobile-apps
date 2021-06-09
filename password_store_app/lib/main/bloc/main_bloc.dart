import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:password_store_app/entity/userdata.dart';
import 'package:rxdart/rxdart.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState());

  @override
  Stream<MainState> mapEventToState(
    MainEvent event,
  ) async* {
    if (event is DataFetched) {
      yield await _fetchedToState(state);
    }

    if (event is DataChanged) {
      yield await _changedToState(state, event);
    }
  }

  @override
  Stream<Transition<MainEvent, MainState>> transformEvents(
    Stream<MainEvent> events,
    TransitionFunction<MainEvent, MainState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  Future<MainState> _fetchedToState(MainState state) async {
    final datas = await _fetchUserData();
    // Iterable<UserData> iterable = datas as Iterable<UserData>;
    return state.copyWith(
        MainStatus.success, List.of(state.userDatas)..addAll(datas));
  }

  Future<MainState> _changedToState(
      MainState state, DataChanged dataChanged) async {
    // print(state.userDatas[dataChanged.index].userPasscode);
    state.userDatas.removeAt(dataChanged.index);
    state.userDatas.insert(dataChanged.index, dataChanged.userData);
    // print(state.userDatas[dataChanged.index].userPasscode);
    // print(state.userDatas[dataChanged.index].userPasscode);
    return state.copyWith(MainStatus.success, state.userDatas);
  }

  Future<List<UserData>> _fetchUserData() async {
    /// 用来测试
    List<UserData> result = await Future.delayed(Duration.zero).then((value) {
      return [
        UserData(appname: "aaa", userId: "aaa2"),
        UserData(appname: "bbb", userId: "bbb2")
      ];
    });

    return result;
  }
}
