import 'package:flutter/material.dart';
import 'package:password_store_app/login/view/gesture_verify.dart';
import 'package:password_store_app/main/view/create_user_data.dart';
import 'package:password_store_app/main/view/main_page.dart';

class Routers {
  static final createUserData = "createUserData";
  static final main = 'main';
  static final verify = 'verify';
  static final Map<String, WidgetBuilder> routers = {
    createUserData: (ctx) => CreateUserDataPage(),
    main: (ctx) => MainPage(),
    verify: (ctx) => GestureVerifyPage()
  };
}
