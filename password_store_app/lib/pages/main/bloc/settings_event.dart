part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsFetched extends SettingsEvent {}

class SettingsChanged extends SettingsEvent {
  final UserSettings settings;
  const SettingsChanged({required this.settings});
}
