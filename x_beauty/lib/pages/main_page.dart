import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:loading_overlay/loading_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:x_beauty/utils/common.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x_beauty/pages/policy_page.dart';
part './convert_page.dart';
part './settings_page.dart';
part './launch_page.dart';
part './draw_face_convertion_page.dart';
part './face_compose_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  static List<Widget> pages = [MainNavigatorPage(), SettingsPage()];

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

class MainNavigatorPage extends StatefulWidget {
  MainNavigatorPage({Key? key}) : super(key: key);

  @override
  _MainNavigatorPageState createState() => _MainNavigatorPageState();
}

class _MainNavigatorPageState extends State<MainNavigatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          CommonUtil.appName,
          style: TextStyle(fontFamily: "MaShanZheng"),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ConvertionPage();
              }));
            },
            title: Text(CommonUtil.pageName1),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return DrawfacePage();
              }));
            },
            title: Text(CommonUtil.pageName2),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return FaceComposePage();
              }));
            },
            title: Text(CommonUtil.pageName3),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
