part of 'settings_bloc.dart';

enum SettingStatus { init, changed }

class SettingsState extends Equatable {
  final SettingStatus status;
  final UserSettings settings;

  const SettingsState(
      {this.status = SettingStatus.init,
      this.settings = const UserSettings(1)});

  @override
  List<Object> get props => [status, settings];

  SettingsState copyWith(SettingStatus? status, UserSettings? settings) {
    return SettingsState(
        status: status ?? this.status, settings: settings ?? this.settings);
  }

  @override
  bool operator ==(Object other) {
    if (this.status == SettingStatus.changed) {
      // print("======================");
      return false;
    }
    return identical(this, other) ||
        other is Equatable &&
            runtimeType == other.runtimeType &&
            qu_utils.equals(props, other.props);
  }

  @override
  int get hashCode => super.hashCode;
}
