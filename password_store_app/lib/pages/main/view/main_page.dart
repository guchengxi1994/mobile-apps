/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-06-18 16:17:05
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-06-18 16:19:21
 */

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:package_info/package_info.dart';
import 'package:password_store_app/entity/user_settings.dart';
import 'package:password_store_app/entity/userdata.dart';
import 'package:password_store_app/pages/main/main_page_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_store_app/pages/main/main_page_widget.dart';
import 'package:password_store_app/pages/main/widget/import_file.dart';
import 'package:password_store_app/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scan/scan.dart';
import 'package:images_picker/images_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:password_store_app/pages/main/view/local_auth_with_fingerprinter.dart';

part 'package:password_store_app/pages/main/view/main_list_page.dart';
part 'package:password_store_app/pages/main/view/settings_page.dart';
part 'package:password_store_app/pages/main/view/extra_components_page.dart';
part 'package:password_store_app/pages/main/view/scan_page.dart';

// MainBloc mainBloc_ = MainBloc();

class MainListPage extends StatefulWidget {
  MainListPage({Key? key}) : super(key: key);

  @override
  _MainListPageState createState() => _MainListPageState();
}

class _MainListPageState extends State<MainListPage> {
  var _futureGetType;
  int _type = 0;
  Future<int> getType() async {
    // await Future.delayed(Duration(seconds: 1));
    var type = getShowType();
    return type;
  }

  @override
  void initState() {
    super.initState();
    _futureGetType = getType();
  }

  Widget _showNormalPopMenu() {
    return new PopupMenuButton(onSelected: (int value) {
      setShowType(value);
      setState(() {
        _type = value;
      });
      Fluttertoast.showToast(
          msg: "??????App?????????",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    }, itemBuilder: (context) {
      return [
        PopupMenuItem(
          child: Text("????????????"),
          value: 0,
        ),
        PopupMenuItem(
          child: Text("????????????"),
          value: 1,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _showNormalPopMenu(),
        ],
        centerTitle: true,
        title: Text("P for Password",
            style: TextStyle(color: Colors.white, fontFamily: "Pangolin")),
      ),
      body: BlocProvider(
        // create: (_) => MainBloc()..add(DataFetched()),
        create: (BuildContext context) {
          return MainBloc()..add(DataFetched());
        },
        // child: UserDataList(
        //   type: 1,
        // ),
        child: FutureBuilder(
          future: _futureGetType,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _type = snapshot.data as int;
              return UserDataList(type: _type);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      // body: UserDataList(),
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

  static List<Widget> pages = [
    MainListPage(),
    ExtraComponents(),
    MainSettingsPage()
  ];

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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "??????"),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "??????"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "??????"),
        ],
      ),
    );
  }
}
