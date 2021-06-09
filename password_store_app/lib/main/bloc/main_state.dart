part of 'main_bloc.dart';

enum MainStatus { initial, changed, success, failure }

class MainState extends Equatable {
  final MainStatus status;
  final List<UserData> userDatas;
  const MainState(
      {this.status = MainStatus.initial, this.userDatas = const []});

  @override
  List<Object> get props => [status, userDatas];

  MainState copyWith(MainStatus? status, List<UserData>? userdatas) {
    return MainState(
        status: status ?? this.status, userDatas: userdatas ?? this.userDatas);
  }

  @override
  bool operator ==(Object other) {
    if (!identical(this, other)) {
      return false;
    } else {
      if (other.runtimeType != this.runtimeType) {
        return false;
      }

      // ignore: test_types_in_equals
      other = other as MainState;
      if (this.status != other.status) {
        return false;
      } else {
        if (this.userDatas.length != other.userDatas.length) {
          return false;
        }
        final length = this.userDatas.length;

        if (length == 0) {
          return false;
        }
        for (var i = 0; i < length; i++) {
          final dynamic unit1 = this.userDatas[i];
          final dynamic unit2 = other.userDatas[i];
          if (unit1 == unit2) {
            return true;
          }
        }
      }
      return false;
    }
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
