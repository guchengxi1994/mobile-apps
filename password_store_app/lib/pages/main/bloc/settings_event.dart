part of 'settings_bloc.dart';

enum SettingStatus { init, changed }

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}
