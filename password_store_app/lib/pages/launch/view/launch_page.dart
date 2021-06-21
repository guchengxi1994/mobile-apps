import 'dart:async';

import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:password_store_app/pages/launch/utils/common.dart';
import 'package:password_store_app/pages/launch/widgets/vertical_text_widget.dart';
import 'package:password_store_app/utils/utils.dart';

EventBus eventBus = new EventBus();

class MyEvent {
  String text;

  MyEvent(this.text);
}

class LauchPage extends StatefulWidget {
  LauchPage({Key? key}) : super(key: key);

  @override
  _LauchPageState createState() => _LauchPageState();
}

class _LauchPageState extends State<LauchPage> {
  late Timer _timer;
  int time = 4;
  var period = const Duration(seconds: 1);
  GlobalKey<TextWidgetState> textKey = GlobalKey();
  final Color _frontColor = ColorUtil.getDynamicWarmColor();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    try {
      //定时器，period为周期
      _timer = Timer.periodic(period, (timer) async {
        eventBus.fire(MyEvent((time - 1).toString()));
        time--;
        if (time <= 0) {
          //取消定时器，销毁事件总线对象
          eventBus.destroy();
          timer.cancel();
          _timer.cancel();
          eventBus.destroy();
          _selfNavigator();
          // var isFirstTimeStart = await getIsFirstLogin();
          // if (isFirstTimeStart) {
          //   Navigator.of(context)
          //       .pushNamedAndRemoveUntil(Routers.create, (route) => false);
          // } else {
          //   int method = await getAppUnlockMethod();
          //   if (method == 1) {
          //     Navigator.of(context)
          //         .pushNamedAndRemoveUntil(Routers.verify, (route) => false);
          //   } else if (method == 2) {
          //     String? psc = await getPscUnlock();
          //     if (null == psc) {
          //       Navigator.of(context).pushNamedAndRemoveUntil(
          //           Routers.textCreate, (route) => false,
          //           arguments: 1);
          //     } else {
          //       Navigator.of(context).pushNamedAndRemoveUntil(
          //           Routers.textVerify, (route) => false);
          //     }
          //   } else {
          //     Navigator.of(context)
          //         .pushNamedAndRemoveUntil(Routers.verify, (route) => false);
          //   }
          // }
        }
      });
    } catch (e) {
      eventBus.destroy();
    }

    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Navigator.pop(context);
    eventBus.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: InkWell(
            onTap: () async {},
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    // color: Color(0xFF006666),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _frontColor,
                          ColorUtil.colorEnd,
                        ]),
                    // borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                Positioned(
                    top: 0.2 * CommonUtil.screenH(),
                    left: 0.15 * CommonUtil.screenW(),
                    width: 0.7 * CommonUtil.screenW(),
                    child: Container(
                      constraints: BoxConstraints(
                        // minWidth: 180,
                        maxHeight: 0.618 * CommonUtil.screenH(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // children: [
                        //   VerticalText(
                        //     getRandomSentence(wildes),
                        //   )
                        // ],
                        children: getRandomSentence(wildes).split("%").map((e) {
                          return VerticalText(e);
                        }).toList(),
                      ),
                    )),
                Positioned(
                  top: 30,
                  right: CommonUtil.screenW() * 0.05,
                  child: TextButton(
                      onPressed: () async {
                        _timer.cancel();
                        eventBus.destroy();
                        _selfNavigator();
                        // var isFirstTimeStart = await getIsFirstLogin();
                        // if (isFirstTimeStart) {
                        //   Navigator.of(context).pushNamedAndRemoveUntil(
                        //       Routers.create, (route) => route == null);
                        // } else {
                        //   Navigator.of(context).pushNamedAndRemoveUntil(
                        //       Routers.verify, (route) => route == null);
                        // }
                      },
                      child: TextWidget()),
                )
              ],
            )),
      ),
    );
  }

  _selfNavigator() async {
    var isFirstTimeStart = await getIsFirstLogin();
    if (isFirstTimeStart) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routers.create, (route) => false);
    } else {
      int method = await getAppUnlockMethod();
      if (method == 1) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routers.verify, (route) => false);
      } else if (method == 2) {
        String? psc = await getPscUnlock();
        if (null == psc) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              Routers.textCreate, (route) => false,
              arguments: 1);
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routers.textVerify, (route) => false);
        }
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routers.verify, (route) => false);
      }
    }
  }
}

//右上角倒计时按钮
class TextWidget extends StatefulWidget {
  int? count;

  TextWidget({Key? key, this.count}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TextWidgetState();
  }
}

class TextWidgetState extends State<TextWidget> {
  String str_sub = '';

  void initState() {
    super.initState();
    //监听MyEvent事件
    eventBus.on<MyEvent>().listen((MyEvent data) {
      if (str_sub != data.text) {
        setState(() {
          str_sub = data.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "${str_sub} 跳过",
        style: TextStyle(fontSize: 15, color: Colors.deepOrange),
      ),
    );
  }
}
