import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_store_app/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

class ImportWidget extends StatefulWidget {
  ImportWidget({Key? key}) : super(key: key);

  @override
  ImportWidgetState createState() => ImportWidgetState();
}

class ImportWidgetState extends State<ImportWidget> {
  double _value = 0.0;
  String _s = "读取数据中...";

  // void setValue(double v) {
  //   this.value = v;
  // }

  @override
  void initState() {
    super.initState();
    check();
  }

  check() async {
    pathExists().then((value) {
      if (value) {
        Future.delayed(Duration(milliseconds: 1000)).then((v) {
          setState(() {
            _s = "导入完成";
            _value = 1.0;
            Future.delayed(Duration(milliseconds: 1000)).then((value) {
              Navigator.of(context).pop();
            });
          });
        });
      } else {
        Future.delayed(Duration(milliseconds: 1000)).then((v) async {
          setState(() {
            _s = "尝试读取导出文件...";
            _value = 0.5;
          });
          Directory appDocDir = await getApplicationDocumentsDirectory();
          String appDocPath = appDocDir.path;
          final _path = appDocPath + "/" + "passcode.txt";
          File f = File(_path);
          try {
            var contents = await f.readAsString();
            print(contents);
            Future.delayed(Duration(milliseconds: 1000)).then((v) {
              setState(() {
                _s = "导入完成";
                _value = 1.0;
                Future.delayed(Duration(milliseconds: 1000)).then((value) {
                  Navigator.of(context).pop();
                });
              });
            });
          } catch (e) {
            setState(() {
              _s = "导入失败";
              _value = 1.0;
              Future.delayed(Duration(milliseconds: 1000)).then((value) {
                Navigator.of(context).pop();
              });
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Text(
                _s,
                style: TextStyle(fontSize: 25, fontFamily: "MaShanZheng"),
              ),
            ),
            SizedBox(
              height: 100.0,
              width: 100,
              child: new CircularProgressIndicator(
                  //0~1的浮点数，用来表示进度多少;如果 value 为 null 或空，则显示一个动画，否则显示一个定值
                  value: _value,
                  //背景颜色
                  backgroundColor: Colors.yellow,
                  //进度颜色
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red)),
            )
          ],
        ),
      ),
    );
  }
}
