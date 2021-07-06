import 'package:password_store_app/entity/user_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getGesturePassword() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? gesturePassword = prefs.getString("password");
  if (null == gesturePassword) {
    gesturePassword = "";
  }
  return gesturePassword;
}

Future<bool> getIsFirstLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? gesturePassword = prefs.getString("password");
  if (null == gesturePassword || "" == gesturePassword) {
    return true;
  } else {
    return false;
  }
}

Future setGesturePassword(String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("password", password);
}

Future<int> getAppUnlockMethod() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? method = prefs.getInt("appunlock");

  if (null == method) {
    method = 1;
    await setAppUnlockMethod(1);
  }
  return method;
}

Future<void> setAppUnlockMethod(int method) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("appunlock", method);
}

Future<UserSettings> getAppUserSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? method = prefs.getInt("appunlock");
  if (null == method) {
    method = 1;
  }
  bool? gestureAvailable = prefs.getBool("gesture");
  if (null == gestureAvailable) {
    gestureAvailable = false;
  }

  bool? pscAvailable = prefs.getBool("psc");
  if (null == pscAvailable) {
    pscAvailable = false;
  }

  bool? fingerprintAvailable = prefs.getBool("fingerprint");
  if (null == fingerprintAvailable) {
    fingerprintAvailable = false;
  }

  UserSettings userSettings = UserSettings(
      method, gestureAvailable, pscAvailable, fingerprintAvailable);

  setUserSettings(userSettings);

  return userSettings;
}

Future<void> setUserSettings(UserSettings settings) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("appunlock", settings.unlockway);
  await prefs.setBool("gesture", settings.gestureAvailable);
  await prefs.setBool("psc", settings.pscAvailable);
  await prefs.setBool("fingerprint", settings.fingerprintAvailable);
}

Future<void> setGestureAvailable(bool f) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("gesture", f);
}

Future<void> setPscAvailable(bool f) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("psc", f);
}

Future<void> setFingerprintAvailable(bool f) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("fingerprint", f);
}

Future<void> setPasscodeUnlock(String s) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("pscunlock", s);
}

Future<String?> getPscUnlock() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? method = prefs.getString("pscunlock");
  return method;
}

Future<int> getShowType() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? type = prefs.getInt("type");
  if (null == type) {
    type = 1;
  }
  return type;
}

Future<void> setShowType(int type) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("type", type);
}
