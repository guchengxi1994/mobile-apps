import 'package:flutter/material.dart';
import 'package:password_store_app/login/view/gesture_create.dart';
import 'package:password_store_app/login/view/gesture_verify.dart';
import 'package:password_store_app/utils/common.dart';
import 'package:password_store_app/utils/databaseUtil.dart';
import 'package:password_store_app/utils/sharepreferenceUtil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var isFirstTimeStart = await getIsFirstLogin();

  runApp(MaterialApp(
    // home: isFirstTimeStart ? GestureCreatePage() : GestureVerifyPage(),
    home: MaterialApp(
      home: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () {
              testSqlite();

              print(UserPasscodeUtil.encode("qwerty"));
            },
            child: Text("点击"),
          ),
        ),
      ),
    ),
  ));
}
