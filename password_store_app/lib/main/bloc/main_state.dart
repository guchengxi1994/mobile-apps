/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-06-09 19:04:04
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-06-09 20:07:17
 */
part of 'main_bloc.dart';

enum MainStatus { initial, changed, success, failure }

class MainState extends Equatable {
  final MainStatus status;
  final List<UserData> userDatas;

  const MainState({
    this.status = MainStatus.initial,
    this.userDatas = const [],
  });

  @override
  List<Object> get props => [status, userDatas];

  MainState copyWith(MainStatus? status, List<UserData>? userdatas) {
    return MainState(
      status: status ?? this.status,
      userDatas: userdatas ?? this.userDatas,
    );
  }

  @override
  bool operator ==(Object other) {
    if (this.status == MainStatus.changed) {
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
