import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:equatable/src/equatable_utils.dart' as qu_utils;
import 'package:password_store_app/entity/user_settings.dart';
import 'package:password_store_app/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState());

  @override
  Stream<Transition<SettingsEvent, SettingsState>> transformEvents(
    Stream<SettingsEvent> events,
    TransitionFunction<SettingsEvent, SettingsState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is SettingsFetched) {
      yield await _fetchToState(state);
    }

    if (event is SettingsChanged) {
      yield await _changeToState(state, event);
    }
  }

  Future<SettingsState> _fetchToState(SettingsState state) async {
    final method = await getAppUnlockMethod();
    return state.copyWith(SettingStatus.init, UserSettings(method));
  }

  Future<SettingsState> _changeToState(
      SettingsState state, SettingsChanged settingsChanged) async {
    await setAppUnlockMethod(settingsChanged.settings.unlockway);
    return state.copyWith(SettingStatus.changed, settingsChanged.settings);
  }
}
