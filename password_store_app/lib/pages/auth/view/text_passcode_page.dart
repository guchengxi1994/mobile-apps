import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_store_app/utils/sharedpreference_util.dart';
import 'package:password_store_app/utils/utils.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class TextPasscodeVerifyPage extends StatefulWidget {
  TextPasscodeVerifyPage({Key? key}) : super(key: key);

  @override
  _TextPasscodeVerifyPageState createState() => _TextPasscodeVerifyPageState();
}

class _TextPasscodeVerifyPageState extends State<TextPasscodeVerifyPage> {
  final int _pinLength = 6;

  TextEditingController _pinEditingController = TextEditingController();

  late PinDecoration _pinDecoration;
  bool _solidEnable = false;
  ColorBuilder _solidColor =
      PinListenColorBuilder(Colors.grey, Colors.grey[400]!);

  PinEntryType _pinEntryType = PinEntryType.boxTight;
  bool _obscureEnable = true;

  String _msg = "请输入密码";

  @override
  void dispose() {
    _pinEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _pinEditingController.addListener(() {
    //   String currentCode = "";
    //   if (currentCode != _pinEditingController.text) {
    //     // debugPrint('controller execute. pin:${_pinEditingController.text}');
    //     currentCode = _pinEditingController.text;
    //   }
    // });
    _pinDecoration = BoxTightDecoration(
      bgColorBuilder: _solidEnable ? _solidColor : null,
      obscureStyle: ObscureStyle(
        isTextObscure: _obscureEnable,
        obscureText: '🤪',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Text("请输入密码", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 50),
              alignment: Alignment.center,
              child: Text(_msg),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 50, left: 10, right: 10),
              child: PinInputTextField(
                pinLength: _pinLength,
                decoration: _pinDecoration,
                autoFocus: true,
                controller: _pinEditingController,
                textInputAction: TextInputAction.go,
                onChanged: (pin) async {
                  if (pin.length == _pinLength) {
                    String? s = await getPscUnlock();
                    if (s == _pinEditingController.text) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Routers.main, (route) => route == null);
                    }
                  }
                },
                onSubmit: (pin) async {
                  // debugPrint('submit pin:$pin');
                  String? s = await getPscUnlock();
                  if (s == _pinEditingController.text) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Routers.main, (route) => route == null);
                  } else {
                    Fluttertoast.showToast(
                        msg: "密码错误",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TextPasscodeCreatePage extends StatefulWidget {
  TextPasscodeCreatePage({Key? key}) : super(key: key);

  @override
  _TextPasscodeCreatePageState createState() => _TextPasscodeCreatePageState();
}

class _TextPasscodeCreatePageState extends State<TextPasscodeCreatePage> {
  final int _pinLength = 6;
  TextEditingController _pinEditingControllerMarked = TextEditingController();
  TextEditingController _pinEditingControllerUnmarked = TextEditingController();
  late PinDecoration _pinDecorationMarked;
  late PinDecoration _pinDecorationUnmarked;
  bool _solidEnable = false;
  ColorBuilder _solidColor =
      PinListenColorBuilder(Colors.grey, Colors.grey[400]!);

  PinEntryType _pinEntryType = PinEntryType.boxTight;
  bool _obscureEnable = true;

  String _guide = "请输入密码";

  String _guide2 = "";

  @override
  void dispose() {
    _pinEditingControllerMarked.dispose();
    _pinEditingControllerUnmarked.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pinDecorationMarked = BoxTightDecoration(
      bgColorBuilder: _solidEnable ? _solidColor : null,
      obscureStyle: ObscureStyle(
        isTextObscure: _obscureEnable,
        obscureText: '🤪',
      ),
    );

    _pinDecorationUnmarked = BoxTightDecoration(
      bgColorBuilder: _solidEnable ? _solidColor : null,
    );

    _pinEditingControllerMarked.addListener(() {
      String currentCode = "";
      if (currentCode != _pinEditingControllerMarked.text) {
        currentCode = _pinEditingControllerMarked.text;
        if (currentCode.length == _pinLength) {
          setState(() {
            _guide = "请再次输入";
          });
        } else {
          setState(() {
            _guide = "请输入密码";
          });
        }
      }
    });

    _pinEditingControllerUnmarked.addListener(() {
      String currentCode = "?";
      if (currentCode != _pinEditingControllerUnmarked.text) {
        currentCode = _pinEditingControllerUnmarked.text;
        if (currentCode.length == _pinLength) {
          if (currentCode == _pinEditingControllerMarked.text) {
            setState(() {
              _guide2 = "输入正确";
            });
          } else {
            setState(() {
              _guide2 = "请保证两次输入一致";
            });
          }
        } else {
          setState(() {
            _guide2 = "";
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Text("请创建解锁密码", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 50),
              alignment: Alignment.center,
              child: Text(_guide),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 50, left: 10, right: 10),
              child: PinInputTextField(
                pinLength: _pinLength,
                decoration: _pinDecorationMarked,
                autoFocus: true,
                controller: _pinEditingControllerMarked,
                textInputAction: TextInputAction.go,
                onSubmit: (pin) {
                  debugPrint('submit pin:$pin');
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              alignment: Alignment.center,
              child: Text(_guide2),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 50, left: 10, right: 10),
              child: PinInputTextField(
                pinLength: _pinLength,
                decoration: _pinDecorationUnmarked,
                autoFocus: true,
                controller: _pinEditingControllerUnmarked,
                textInputAction: TextInputAction.go,
                onSubmit: (pin) {
                  debugPrint('submit pin:$pin');
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text("取消")),
                ElevatedButton(
                    onPressed: () {
                      _pinEditingControllerUnmarked.text = "";
                      _pinEditingControllerMarked.text = "";
                    },
                    child: Text("重置")),
                ElevatedButton(
                    onPressed: () async {
                      if (_guide2 == "输入正确") {
                        await setPasscodeUnlock(
                            _pinEditingControllerUnmarked.text);
                        if (message == 1) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routers.main, (route) => route == null);
                        } else {
                          Navigator.pop(context, true);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "输入有错误",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: Text("确定")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
