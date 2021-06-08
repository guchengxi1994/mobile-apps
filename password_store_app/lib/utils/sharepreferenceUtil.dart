import 'package:shared_preferences/shared_preferences.dart';

Future<String> getGesturePassword() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String gesturePassword = prefs.getString("password");
  if (null == gesturePassword) {
    gesturePassword = "";
  }
  return gesturePassword;
}

Future<bool> getIsFirstLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String gesturePassword = prefs.getString("password");
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
