/// 弃用

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:password_store_app/entity/userdata.dart';
import 'package:password_store_app/pages/main/widget/list_tile_dialog.dart';
import 'package:password_store_app/utils/common.dart';

final double _padding = 32;

class UserDataWidget extends StatefulWidget {
  final UserData userData;
  UserDataWidget(
    this.userData, {
    Key? key,
  }) : super(key: key);

  @override
  _UserDataWidgetState createState() => _UserDataWidgetState();
}

class _UserDataWidgetState extends State<UserDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.all(_padding),
      // color: Color(0x00000000),
      // color: Colors.red,
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        back: Container(
          padding: EdgeInsets.all(_padding),
          decoration: BoxDecoration(
            color: Color(0xFF006666),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _renderContent("口令类型", widget.userData.passcodeType, fixed: true),
              _renderContent("scheme", widget.userData.scheme, fixed: false),
            ],
          ),
        ),
        front: Container(
          padding: EdgeInsets.all(_padding),
          decoration: BoxDecoration(
            color: Color(0xFF006666),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _renderContent("应用名称", widget.userData.appname.toString()),
              _renderContent("用户名", widget.userData.userId.toString()),
              _renderContent("用户口令", widget.userData.userPasscode.toString(),
                  customTrailing: strValid(widget.userData.userPasscode)
                      ? TextButton(
                          onPressed: () {
                            print("点击了复制");
                          },
                          child: Text("复制到剪切板"))
                      : TextButton(
                          onPressed: () {
                            print("点击了生成");
                            setState(() {
                              widget.userData.userPasscode = "修改后";
                            });
                          },
                          child: Text("修改code"))),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _renderContent(String title, dynamic content,
      // ignore: unused_element
      {bool fixed = false,
      Widget? customTrailing}) {
    return Row(
      children: [
        Text(title + ":" + content.toString()),
        customTrailing == null
            ? (fixed
                ? Container()
                : TextButton(
                    child: Text("修改"),
                    onPressed: () async {
                      // print("点击了修改");
                      var result = showCustomDialog(context);
                    },
                  ))
            : customTrailing,
      ],
    );
  }
}
