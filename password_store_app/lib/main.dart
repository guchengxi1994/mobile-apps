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
import 'package:password_store_app/pages/launch/view/launch_page.dart';
import 'package:password_store_app/pages/main/main_page_view.dart';
import 'package:password_store_app/utils/utils.dart';

main(List<String> args) async {
  Bloc.observer = Observer();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MaterialApp(
    routes: Routers.routers,
    // home: LauchPage(),
    home: MainPage(),
    // home: Draw(),
  ));
}
