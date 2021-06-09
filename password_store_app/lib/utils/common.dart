import 'dart:convert';
import 'dart:math';

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
  static List<String> encode(String psc, {int saltLength = 10}) {
    String code = '';
    String b64Code = encodeBase64(psc);
    int pscLength = b64Code.length;
    String salt = '';
    while (true) {
      salt = generateSalt();
      if (!psc.contains(salt)) {
        if (pscLength == 0) {
          code = salt;
        } else {
          List l = pscSplit(b64Code);
          code = l[0] + salt + l[1];
          // print("======================");
          // print(l[0]);
          // print(l[1]);
          // print("======================");
        }
        break;
      }
    }
    return [code, salt];
  }

  static String decode(String psc, String salt) {
    return decodeBase64(psc.replaceAll(psc, salt));
  }

  static String alphabet =
      "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890";

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
