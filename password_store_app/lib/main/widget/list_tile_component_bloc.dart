/// using bloc rewrite ./list_tile.dart

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:password_store_app/entity/userdata.dart';
import 'package:password_store_app/main/bloc/main_bloc.dart';
import 'package:password_store_app/main/widget/list_tile_dialog.dart';
import 'package:password_store_app/utils/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final double _padding = 32;

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
  @override
  void initState() {
    super.initState();
    _mainBloc = context.read<MainBloc>();
    _currentUserData =
        UserData.fromJson(_mainBloc.state.userDatas[widget.index].toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.all(_padding),
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
              _renderContent(
                  "口令类型", _mainBloc.state.userDatas[widget.index].passcodeType,
                  fixed: true),
              _renderContent(
                  "scheme", _mainBloc.state.userDatas[widget.index].scheme,
                  fixed: false),
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
              _renderContent("应用名称",
                  _mainBloc.state.userDatas[widget.index].appname.toString()),
              _renderContent("用户名",
                  _mainBloc.state.userDatas[widget.index].userId.toString()),
              _renderContent(
                  "用户口令",
                  _mainBloc.state.userDatas[widget.index].userPasscode
                      .toString(),
                  customTrailing: strValid(
                          _mainBloc.state.userDatas[widget.index].userPasscode)
                      ? TextButton(
                          onPressed: () {
                            print("点击了复制");
                          },
                          child: Text("复制到剪切板"))
                      : TextButton(
                          onPressed: () {
                            print("点击了生成");
                            _currentUserData.userPasscode =
                                "passcode" + widget.index.toString();
                            _mainBloc.add(DataChanged(
                                index: widget.index,
                                userData: _currentUserData));
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
