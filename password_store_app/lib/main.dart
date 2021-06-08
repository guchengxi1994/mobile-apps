/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-06-08 19:04:21
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-06-08 19:07:22
 */
import 'package:flutter/material.dart';
import 'package:password_store_app/login/view/gesture_create.dart';
import 'package:password_store_app/login/view/gesture_verify.dart';
import 'package:password_store_app/utils/common.dart';
import 'package:password_store_app/utils/database_util.dart';
import 'package:password_store_app/utils/sharedpreference_util.dart';

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
