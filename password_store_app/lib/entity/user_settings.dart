import 'package:equatable/equatable.dart';
import 'package:password_store_app/utils/utils.dart';

class UserSettings extends Equatable {
  final int unlockway; // 手势，密码，指纹
  final bool gestureAvailable;
  final bool pscAvailable;
  final bool fingerprintAvailable;

  const UserSettings(this.unlockway, this.gestureAvailable, this.pscAvailable,
      this.fingerprintAvailable);

  @override
  // TODO: implement props
  List<Object?> get props => [this.unlockway];

  static const empty = UserSettings(1, true, false, false);

  String toParamString({int paramIndex = 0}) {
    return unLockMethods[this.unlockway - 1];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['unlockway'] = this.unlockway;
  //   return data;
  // }
}
