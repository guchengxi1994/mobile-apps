import 'package:flutter/cupertino.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthSingleton {
  static LocalAuthSingleton _instance = LocalAuthSingleton._internal();
  factory LocalAuthSingleton() => _instance;

  LocalAuthentication? auth;

  LocalAuthSingleton._internal() {
    if (null == auth) {
      auth = new LocalAuthentication();
    }
  }

  Future<bool> checkBiometrics() async {
    bool biometricsAvailable;
    try {
      biometricsAvailable = await auth!.canCheckBiometrics;
    } catch (e) {
      biometricsAvailable = false;
    }
    return biometricsAvailable;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth!.getAvailableBiometrics();
    } catch (e) {
      availableBiometrics = [];
    }
    return availableBiometrics;
  }

  Future<bool> authenticate(BuildContext context) async {
    bool authenticated = false;

    try {
      authenticated = await auth!.authenticate(
          localizedReason: "身份验证",
          stickyAuth: true,
          biometricOnly: true,
          androidAuthStrings: const AndroidAuthMessages(
            biometricNotRecognized: "失败",
            biometricSuccess: "成功",
            cancelButton: "取消",
            deviceCredentialsRequiredTitle: "必须进行指纹认证或面部认证设置",
            deviceCredentialsSetupDescription: "请设置",
          ));
    } catch (e) {
      print(e);
      authenticated = false;
    }
    return authenticated;
  }
}
