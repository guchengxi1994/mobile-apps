import 'package:flutter/material.dart';
import "dart:ui" as _ui;

import 'package:shared_preferences/shared_preferences.dart';

class CommonUtil {
  /// 获取屏幕大小
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(_ui.window);
  static double _width = mediaQuery.size.width;
  static double _height = mediaQuery.size.height;
  static screenW() {
    return _width;
  }

  static screenH() {
    return _height;
  }

  static String appIcon = 'assets/images/icon.png';
  static String appName = "AI人像转换工具";

  static String pageName1 = "人像转换工具";
  static String pageName2 = "手绘转换工具";

  static TextStyle jobNameStyle =
      TextStyle(fontSize: 17, fontWeight: FontWeight.bold);

  /// 字体样式
  static TextStyle fontStyle = TextStyle(fontWeight: FontWeight.bold);
}

Future<bool> checkFirstLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? _isFirstStartApp = prefs.getBool("isFirstStartApp");
  if (null == _isFirstStartApp) {
    _isFirstStartApp = true;
  }
  return _isFirstStartApp;
}

Future<bool> checkPolicyAgreed() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? _agreed = prefs.getBool("agreed");
  if (null == _agreed) {
    _agreed = false;
  }
  return _agreed;
}

Future setPolicyAgreed() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // bool _agreed = prefs.getBool("agreed");
  await prefs.setBool("agreed", true);
}
