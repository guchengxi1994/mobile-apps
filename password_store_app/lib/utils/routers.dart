import 'package:flutter/material.dart';
import 'package:password_store_app/pages/auth/auth_page_view.dart';
import 'package:password_store_app/pages/main/view/create_user_data.dart';
import 'package:password_store_app/pages/main/view/main_page.dart';

class Routers {
  static final createUserData = "createUserData";
  static final main = 'main';
  static final verify = 'verify';
  static final create = 'create';
  static final textCreate = 'textCreate';
  static final textVerify = 'textVerify';
  static final Map<String, WidgetBuilder> routers = {
    createUserData: (ctx) => CreateUserDataPage(),
    main: (ctx) => MainPage(),
    verify: (ctx) => GestureVerifyPage(),
    create: (ctx) => GestureCreatePage(),
    textCreate: (ctx) => TextPasscodeCreatePage(),
    textVerify: (ctx) => TextPasscodeVerifyPage()
  };
}
