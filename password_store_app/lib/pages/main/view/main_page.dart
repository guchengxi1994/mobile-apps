/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-06-18 16:17:05
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-06-18 16:19:21
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:password_store_app/entity/user_settings.dart';
import 'package:password_store_app/entity/userdata.dart';
import 'package:password_store_app/pages/main/bloc/settings_bloc.dart';
import 'package:password_store_app/pages/main/main_page_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_store_app/pages/main/main_page_widget.dart';
import 'package:password_store_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

part 'package:password_store_app/pages/main/view/main_list_page.dart';
part 'package:password_store_app/pages/main/view/settings_page.dart';

class MainListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("P for Password",
            style: TextStyle(color: Colors.white, fontFamily: "Pangolin")),
      ),
      body: BlocProvider(
        create: (_) => MainBloc()..add(DataFetched()),
        child: UserDataList(),
      ),
    );
  }
}

class MainSettingsPage extends StatelessWidget {
  const MainSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc()..add(SettingsFetched()),
      child: SettingsPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  static List<Widget> pages = [MainListPage(), MainSettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: this.currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this.currentIndex,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            this.currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "设置"),
        ],
      ),
    );
  }
}
