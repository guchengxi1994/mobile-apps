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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_store_app/login/view/gesture_create.dart';
import 'package:password_store_app/login/view/gesture_verify.dart';
import 'package:password_store_app/main/view/main_page.dart';
import 'package:password_store_app/observer.dart';
import 'package:password_store_app/utils/database_util.dart';
import 'package:password_store_app/utils/routers.dart';
import 'package:password_store_app/utils/sharedpreference_util.dart';

main(List<String> args) async {
  Bloc.observer = Observer();
  WidgetsFlutterBinding.ensureInitialized();
  var isFirstTimeStart = await getIsFirstLogin();
  // await testSqlite();
  runApp(new MaterialApp(
    routes: Routers.routers,
    // home: isFirstTimeStart ? GestureCreatePage() : GestureVerifyPage(),
    home: MainPage(),
  ));
}
