import 'dart:convert';

/// using bloc to rewrite ./list_tile.dart

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_store_app/entity/userdata.dart';
import 'package:password_store_app/pages/main/main_page_bloc.dart';
import 'package:password_store_app/pages/main/view/local_auth_with_fingerprinter.dart';
import 'package:password_store_app/pages/main/main_page_widget.dart';
import 'package:password_store_app/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

final double _padding = 32;
final double _cardHeight = 200;

final _fontSize = 20;

final Color _frontColor = ColorUtil.getDynamicWarmColor();
final Color _backColor = ColorUtil.getDynamicColdColor();

class UserDataWidget extends StatefulWidget {
  // final UserData userData;
  final int index;
  UserDataWidget(
    // this.userData,
    this.index, {
    Key? key,
  }) : super(key: key);

  @override
  _UserDataWidgetState createState() => _UserDataWidgetState();
}

class _UserDataWidgetState extends State<UserDataWidget> {
  late MainBloc _mainBloc;
  late UserData _currentUserData;

  bool _checkboxSelectedFuzzy = true;
  // bool _checkboxSelectedRandom = true;

  @override
  void initState() {
    super.initState();
    _mainBloc = context.read<MainBloc>();
    _currentUserData =
        UserData.fromJson(_mainBloc.state.userDatas[widget.index].toJson());
    _checkboxSelectedFuzzy = _currentUserData.isFuzzy!;
    // _checkboxSelectedRandom = _currentUserData.isRandom!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.all(_padding),
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        back: Container(
          // width: 0.85 * CommonUtil.screenW(),
          padding: EdgeInsets.all(_padding),
          constraints: BoxConstraints(minHeight: _cardHeight),
          decoration: BoxDecoration(
            // color: Color(0xFF006666),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _backColor,
                  ColorUtil.colorEnd,
                ]),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _renderContentWithBloc(
                  "scheme", _mainBloc.state.userDatas[widget.index].scheme,
                  colorStyle: 0),
              ElevatedButton(
                  onPressed: () {
                    // print(json.encode(
                    //     _mainBloc.state.userDatas[widget.index].toJson()));
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text("二维码共享"),
                            content: Center(
                              child: Container(
                                height: 200,
                                width: 200,
                                child: QrImage(
                                  data: json
                                      .encode(_mainBloc
                                          .state.userDatas[widget.index]
                                          .toJson())
                                      .toString(),
                                  version: QrVersions.auto,
                                  size: 200.0,
                                ),
                              ),
                            ),
                            actions: [
                              CupertinoDialogAction(
                                child: Text('关闭'),
                                isDestructiveAction: true,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: Text("二维码共享")),
              ElevatedButton(
                  onPressed: () async {
                    var res = await showConfirmDialog(context);
                    print(widget.index);
                    if (res) {
                      _mainBloc.add(DataDelete(
                          index: widget.index, userData: _currentUserData));
                    }
                  },
                  child: Text("移除")),
            ],
          ),
        ),
        front: Container(
          // width: 0.85 * CommonUtil.screenW(),
          padding: EdgeInsets.all(_padding),
          constraints: BoxConstraints(minHeight: _cardHeight),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _frontColor,
                  ColorUtil.colorEnd,
                ]),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text("编号： " + widget.index.toString()),
              ),
              _renderContentWithBloc(
                  "应用名称", _mainBloc.state.userDatas[widget.index].appname,
                  colorStyle: 1),
              Divider(
                thickness: 5,
              ),
              _renderContentWithBloc(
                  "用户昵称", _mainBloc.state.userDatas[widget.index].userId,
                  colorStyle: 1),
              Divider(
                thickness: 5,
              ),
              _renderContentWithBloc(
                  "用户口令", _mainBloc.state.userDatas[widget.index].userPasscode,
                  colorStyle: 1)
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          title + ":" + content.toString(),
          maxLines: 3,
        ),
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

  Widget _renderContentWithBloc(String title, dynamic content,
      {int colorStyle = 0}) {
    Widget w;
    switch (title) {
      case "用户口令":
        w = Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(title + ": ",
                    style: TextStyle(
                        color: Colors.black, fontSize: _fontSize * 1.0)),
                Spacer(),
                Row(
                  children: [
                    Checkbox(
                        value: _checkboxSelectedFuzzy,
                        onChanged: (value) {
                          // print("aaaaaaaa");
                          setState(() {
                            _checkboxSelectedFuzzy = value!;
                          });
                        }),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _checkboxSelectedFuzzy = !_checkboxSelectedFuzzy;
                        });
                      },
                      child: Text("是否混淆?"),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(content ?? "",
                      style: TextStyle(
                          color: Colors.black, fontSize: _fontSize * 1.0)),
                ),
                // Spacer(),
                strValid(_mainBloc.state.userDatas[widget.index].userPasscode)
                    ? Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                _currentUserData = UserData.fromJson(_mainBloc
                                    .state.userDatas[widget.index]
                                    .toJson());
                                List<String> l =
                                    UserPasscodeUtil.generateRandomPasscode(
                                            isFuzzy: _checkboxSelectedFuzzy)
                                        as List<String>;

                                _currentUserData.userPasscode = l[0];
                                _currentUserData.isFuzzy =
                                    _checkboxSelectedFuzzy;
                                _currentUserData.salt = l[1];
                                _mainBloc.add(DataChanged(
                                    index: widget.index,
                                    userData: _currentUserData));
                              },
                              child: Text("重设")),
                          TextButton(
                              onPressed: () async {
                                // local_auth
                                LocalAuthSingleton singleton =
                                    LocalAuthSingleton();
                                if (await singleton.checkBiometrics()) {
                                  var res =
                                      await singleton.authenticate(context);
                                  if (res) {
                                    Clipboard.setData(ClipboardData(
                                        text: UserPasscodeUtil.decode(
                                            _mainBloc
                                                .state
                                                .userDatas[widget.index]
                                                .userPasscode!,
                                            _mainBloc.state
                                                .userDatas[widget.index].salt!,
                                            isFuzzy: _mainBloc
                                                .state
                                                .userDatas[widget.index]
                                                .isFuzzy!)));
                                    Fluttertoast.showToast(
                                        msg: "复制成功",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 2,
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "未设定指纹验证，请取消混淆并重置密码后手动输入",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                              child: Text("复制"))
                        ],
                      )
                    : TextButton(
                        onPressed: () {
                          // print("点击了生成");
                          _currentUserData = UserData.fromJson(
                              _mainBloc.state.userDatas[widget.index].toJson());

                          List<String> l =
                              UserPasscodeUtil.generateRandomPasscode(
                                      isFuzzy: _checkboxSelectedFuzzy)
                                  as List<String>;

                          _currentUserData.userPasscode = l[0];
                          _currentUserData.isFuzzy = _checkboxSelectedFuzzy;
                          _currentUserData.salt = l[1];
                          _mainBloc.add(DataChanged(
                              index: widget.index, userData: _currentUserData));
                        },
                        child: Text("修改code")),
              ],
            )
          ],
        );
        break;
      case "scheme":
        w = Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RichText(
                text: TextSpan(
              children: [
                TextSpan(
                    text: title + ": ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: _fontSize * 1.0,
                    )),
                TextSpan(
                    text: content.toString(),
                    style: TextStyle(
                        fontSize: _fontSize * 1.0,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.dashed,
                        fontWeight: FontWeight.bold,
                        color: colorStyle == 1 ? _backColor : _frontColor)),
              ],
            )),
            Spacer(),
            TextButton(
                onPressed: () async {
                  var _result = await showCustomDialog(context);
                  if (_result != "" && _result != null) {
                    _currentUserData = UserData.fromJson(
                        _mainBloc.state.userDatas[widget.index].toJson());
                    _currentUserData.scheme = _result.toString();
                    _mainBloc.add(DataChanged(
                        index: widget.index, userData: _currentUserData));
                  }
                },
                child: Text("修改")),
            TextButton(
              child: Text("跳转"),
              onPressed: () async {
                print("点击了跳转");
                // var result = showCustomDialog(context);
              },
            ),
          ],
        );
        break;
      default:
        w = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(title + ": ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: _fontSize * 1.0,
                        ))),
              ],
            ),
            Row(
              children: [
                Text(content.toString(),
                    style: TextStyle(
                        fontSize: _fontSize * 1.0,
                        fontWeight: FontWeight.bold,
                        color: colorStyle == 1 ? _backColor : _frontColor)),
                Spacer(),
                TextButton(
                  child: Text("修改"),
                  onPressed: () async {
                    // print("点击了修改");
                    _currentUserData = UserData.fromJson(
                        _mainBloc.state.userDatas[widget.index].toJson());
                    var result = await showCustomDialog(context);
                    if (null != result) {
                      if (title == "应用名称") {
                        _currentUserData.appname = result;
                      } else {
                        _currentUserData.userId = result;
                      }
                      _mainBloc.add(DataChanged(
                          index: widget.index, userData: _currentUserData));
                    }
                  },
                ),
              ],
            ),
          ],
        );

        // w = Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     RichText(
        //         text: TextSpan(
        //       children: [
        //         TextSpan(
        //             text: title + ": ",
        //             style: TextStyle(
        //               color: Colors.black,
        //               fontSize: _fontSize * 1.0,
        //             )),
        //         TextSpan(
        //             text: content.toString(),
        //             style: TextStyle(
        //                 fontSize: _fontSize * 1.0,
        //                 fontWeight: FontWeight.bold,
        //                 color: colorStyle == 1 ? _backColor : _frontColor)),
        //       ],
        //     )),
        //     Spacer(),
        //     TextButton(
        //       child: Text("修改"),
        //       onPressed: () async {
        //         // print("点击了修改");
        //         _currentUserData = UserData.fromJson(
        //             _mainBloc.state.userDatas[widget.index].toJson());
        //         var result = await showCustomDialog(context);
        //         if (null != result) {
        //           if (title == "应用名称") {
        //             _currentUserData.appname = result;
        //           } else {
        //             _currentUserData.userId = result;
        //           }
        //           _mainBloc.add(DataChanged(
        //               index: widget.index, userData: _currentUserData));
        //         }
        //       },
        //     ),
        //   ],
        // );
        break;
    }
    return w;
  }
}
