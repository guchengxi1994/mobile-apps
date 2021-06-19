import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import "dart:ui" as _ui;

int bool2int(bool b) {
  if (b == true) {
    return 1;
  } else {
    return 0;
  }
}

bool int2bool(int a) {
  if (a > 0) {
    return true;
  } else {
    return false;
  }
}

class UserPasscodeUtil {
  static List<String> encode(String psc, {int saltLength = 6}) {
    String code = '';
    String b64Code = encodeBase64(psc);
    int pscLength = b64Code.length;
    String salt = '';
    while (true) {
      salt = generateSalt(length: saltLength);
      if (!psc.contains(salt)) {
        if (pscLength == 0) {
          code = salt;
        } else {
          List l = pscSplit(b64Code);
          code = l[0] + salt + l[1];
        }
        break;
      }
    }
    return [code, salt];
  }

  static List<String?>? generateRandomPasscode({bool isFuzzy = true}) {
    List<String> l = encode("", saltLength: 12);
    String res = l[0];
    // print('========================================');
    // print(l[0]);
    // print('========================================');

    if (isFuzzy) {
      res = encodeBase64(l[0]);
    }
    String salt = generateSalt(length: 6);
    List spl = pscSplit(res);
    var code = spl[0] + salt + spl[1];
    // print(salt);
    // print(spl[0]);
    // print(spl[1]);
    // print(code);

    return [code, salt];
  }

  static String decode(String psc, String salt, {bool isFuzzy = true}) {
    if (isFuzzy) {
      return decodeBase64(psc.replaceAll(salt, ""));
    } else {
      return psc.replaceAll(salt, "");
    }
  }

  static String alphabet =
      "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890!@#%*&";

  static String generateSalt({int length = 10}) {
    String left = '';
    for (var i = 0; i < length; i++) {
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    // print(left.length);
    return left;
  }

  static List<String> pscSplit(String psc) {
    int index = Random().nextInt(psc.length);
    String s1 = psc.substring(0, index + 1);
    String s2 = psc.substring(index + 1);
    return [s1, s2];
  }

  /*
  * Base64加密
  */
  static String encodeBase64(String data) {
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  /*
  * Base64解密
  */
  static String decodeBase64(String data) {
    return String.fromCharCodes(base64Decode(data));
  }
}

bool strValid(String? s) {
  if (null != s && s != "") {
    return true;
  } else {
    return false;
  }
}

/// 弃用
bool listEquals(List l1, List l2) {
  if (l1.length != l2.length) {
    return false;
  }

  bool flag = true;
  final int length = l1.length;
  try {
    for (var i = 0; i < length; i++) {
      if (l1[i] != l2[i]) {
        flag = false;
        break;
      }
    }
  } catch (e) {
    flag = false;
  }

  return flag;
}

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
}
