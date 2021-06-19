import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_store_app/entity/userdata.dart';
import 'package:password_store_app/pages/main/main_page_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_store_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateUserDataPage extends StatefulWidget {
  CreateUserDataPage({Key? key}) : super(key: key);

  @override
  _CreateUserDataPageState createState() => _CreateUserDataPageState();
}

class _CreateUserDataPageState extends State<CreateUserDataPage> {
  late UserData? _userData;
  late TextEditingController appController;
  late TextEditingController usernameController;
  late TextEditingController passcodeController;
  late TextEditingController schemeController;
  late TextEditingController codeTypeController;
  String _adType = "";

  List<String> fuzzyType = ['是', '否'];

  @override
  void initState() {
    super.initState();
    appController = TextEditingController();
    usernameController = TextEditingController();
    passcodeController = TextEditingController();
    schemeController = TextEditingController();
    codeTypeController = TextEditingController();
    codeTypeController.text = "未知";

    _userData = UserData(userId: "", appname: "");

    passcodeController.addListener(() {
      if (passcodeController.text == "") {
        codeTypeController.text = "未知";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
          child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/background.jpg"))),
        child: Opacity(
          opacity: 0.8,
          child: Container(
            // height: 500,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(15),
              border: new Border.all(width: 1, color: Colors.grey[900]!),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Table(
                  columnWidths: const {
                    //列宽
                    0: FixedColumnWidth(100.0),
                    1: FixedColumnWidth(200.0),
                    2: FixedColumnWidth(50.0),
                  },
                  border: TableBorder.all(
                    color: Colors.green,
                    width: 2.0,
                    style: BorderStyle.solid,
                  ),
                  children: [
                    TableRow(
                        //第一行样式 添加背景色
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                        children: [
                          //增加行高
                          SizedBox(
                            height: 30.0,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                '参数名',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          Container(
                            height: 30,
                            alignment: Alignment.center,
                            child: Text(
                              '参数数值',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                    TableRow(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                        children: [
                          Container(
                            height: 50,
                            padding: EdgeInsets.all(3),
                            alignment: Alignment.center,
                            child: Text("App 名"),
                          ),
                          Container(
                            height: 50,
                            // alignment: Alignment.center,
                            padding: EdgeInsets.all(3),
                            child: TextField(
                              maxLines: 3,
                              controller: appController,
                            ),
                          ),
                          Container(
                            child: TextButton(
                              child: Text("随机生成"),
                              onPressed: () {
                                // print("点击了随机");
                                appController.text = "APPNAME_" +
                                    UserPasscodeUtil.generateSalt(length: 6);
                              },
                            ),
                          )
                        ]),
                    TableRow(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                        children: [
                          Container(
                            height: 50,
                            padding: EdgeInsets.all(3),
                            alignment: Alignment.center,
                            child: Text("用户名"),
                          ),
                          Container(
                            height: 50,
                            // alignment: Alignment.center,
                            padding: EdgeInsets.all(3),
                            child: TextField(
                              maxLines: 3,
                              controller: usernameController,
                            ),
                          ),
                          Container(
                            child: TextButton(
                              child: Text("随机生成"),
                              onPressed: () {
                                // print("点击了随机");
                                usernameController.text =
                                    UserPasscodeUtil.generateSalt(length: 6);
                              },
                            ),
                          )
                        ]),
                    TableRow(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                        children: [
                          Container(
                            height: 50,
                            padding: EdgeInsets.all(3),
                            alignment: Alignment.center,
                            child: Text("code"),
                          ),
                          Container(
                            height: 50,
                            // alignment: Alignment.center,
                            padding: EdgeInsets.all(3),
                            child: TextField(
                              maxLines: 3,
                              controller: passcodeController,
                            ),
                          ),
                          Container(
                            child: TextButton(
                              child: Text("随机生成"),
                              onPressed: () {
                                print("点击了随机");
                              },
                            ),
                          )
                        ]),
                    TableRow(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                        children: [
                          Container(
                            height: 50,
                            padding: EdgeInsets.all(3),
                            alignment: Alignment.center,
                            child: Text("scheme"),
                          ),
                          Container(
                            height: 50,
                            // alignment: Alignment.center,
                            padding: EdgeInsets.all(3),
                            child: TextField(
                              maxLines: 3,
                              controller: schemeController,
                            ),
                          ),
                          Container(
                            child: TextButton(
                              child: Text("尝试唤醒"),
                              onPressed: () {
                                // print("点击了随机");
                                /// 测试 微信   "weixin://"

                                if (schemeController.text == "") {
                                  Fluttertoast.showToast(
                                      msg: "scheme 不能为空！",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: Colors.orange,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {
                                  try {
                                    launch(schemeController.text);
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                        msg: "唤醒失败",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 2,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                }
                              },
                            ),
                          )
                        ]),
                    TableRow(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                        children: [
                          Container(
                            height: 50,
                            padding: EdgeInsets.all(3),
                            alignment: Alignment.center,
                            child: Text("是否混淆"),
                          ),
                          Container(
                            height: 50,
                            width: 200,
                            // alignment: Alignment.center,
                            padding: EdgeInsets.all(3),
                            child: getDropdownAdtype(fuzzyType),
                          ),
                          Container()
                        ]),
                    TableRow(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                        children: [
                          Container(
                            height: 50,
                            padding: EdgeInsets.all(3),
                            alignment: Alignment.center,
                            child: Text("密码类型"),
                          ),
                          Container(
                            height: 50,
                            // alignment: Alignment.center,
                            padding: EdgeInsets.all(3),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              enabled: false,
                              controller: codeTypeController,
                            ),
                          ),
                          Container()
                        ]),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("取消")),
                    Container(
                      width: 50,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          appController.text = "";
                          usernameController.text = "";
                          passcodeController.text = "";
                          schemeController.text = "";
                          // codeTypeController.text = "";
                          _adType = "默认“是”";
                          setState(() {});
                        },
                        child: Text("重置")),
                    // Spacer(),
                    Container(
                      width: 50,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _userData?.appname = appController.text;
                          _userData?.userPasscode = passcodeController.text;
                          _userData?.scheme = schemeController.text;
                          _userData?.userId = usernameController.text;
                          Navigator.pop(context, _userData);
                        },
                        child: Text("提交")),
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget getDropdownAdtype(List l) {
    return Container(
      child: DropdownButton(
        hint: Container(
          child: Text(
            _adType == "" ? "默认“是”" : _adType,
            style: _adType == ""
                ? TextStyle(
                    color: Colors.blue,
                  )
                : null,
          ),
        ),
        // isExpanded: true,
        items: l.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e.toString()),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _adType = value.toString();
          });
        },
      ),
    );
  }
}

// class CreateUserPage extends StatelessWidget {
//   const CreateUserPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocProvider(
//         create: (_) => MainBloc()..add(DataFetched()),
//         child: CreateUserDataPage(),
//       ),
//     );
//   }
// }
