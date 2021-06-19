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
