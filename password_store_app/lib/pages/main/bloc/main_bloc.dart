/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-06-09 19:04:04
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-06-09 20:06:37
 */
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:password_store_app/entity/userdata.dart';
import 'package:password_store_app/pages/main/main_page_bloc.dart';
import 'package:password_store_app/utils/database_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/src/equatable_utils.dart' as qu_utils;

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

    if (event is DataAdded) {
      yield await _addToState(state, event);
    }

    if (event is DataDelete) {
      yield await _deleteToState(state, event);
    }

    if (event is DataFilter) {
      yield await _filterToState(state, event);
    }

    if (event is DataAddList) {
      yield await _addList(state, event);
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
    // state.userDatas.clear();
    if (null != datas) {
      return state.copyWith(
          MainStatus.success,
          List.of(state.userDatas)
            ..clear()
            ..addAll(datas));
    } else {
      return state;
    }
  }

  Future<MainState> _changedToState(
      MainState state, DataChanged dataChanged) async {
    // print(state.userDatas[dataChanged.index].toJson());

    // print(dataChanged.userData.toJson());

    if (state.userDatas[dataChanged.index] != dataChanged.userData) {
      state.userDatas[dataChanged.index] = dataChanged.userData;
      updateData(dataChanged.userData);
      return state.copyWith(MainStatus.changed, state.userDatas);
    } else {
      return state.copyWith(MainStatus.success, state.userDatas);
    }
  }

  Future<MainState> _addToState(MainState state, DataAdded dataAdded) async {
    // state.userDatas.add(dataAdded.userData);
    await insertToDB(dataAdded.userData);
    return state.copyWith(
        MainStatus.changed, List.of(state.userDatas)..add(dataAdded.userData));
  }

  Future<MainState> _deleteToState(
      MainState state, DataDelete dataDelete) async {
    state.userDatas.removeAt(dataDelete.index);
    await deleteData(dataDelete.userData.rid!);
    return state.copyWith(MainStatus.changed, state.userDatas);
  }

  Future<MainState> _filterToState(MainState state, DataFilter filter) async {
    var searchedResults = state.userDatas
        .where((element) => element.appname!.contains(filter.searchStr))
        .toList();
    return state.copyWith(MainStatus.changed, searchedResults);
  }

  Future<List<UserData>?> _fetchUserData() async {
    var res = await fetchUserData();
    return res;
  }

  Future<MainState> _addList(MainState state, DataAddList dataAddList) async {
    for (var i in dataAddList.datas) {
      await insertToDB(i);
    }
    return state.copyWith(MainStatus.success,
        List.of(state.userDatas)..addAll(dataAddList.datas));
  }
}
