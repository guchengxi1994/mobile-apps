part of './main_page.dart';

const fontSize = 14.0;

class LaunchPage extends StatefulWidget {
  LaunchPage({Key? key}) : super(key: key);

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage>
    with AfterLayoutMixin<LaunchPage> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    checkFirstLogin().then((value) {
      if (value) {
        showPolicyDialog();
      }
    });
  }

  showPolicyDialog() async {
    var result = await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("隐私政策"),
            content: Container(
                height: 0.5 * CommonUtil.screenH(),
                child: PolicyPage(
                  withTitle: false,
                )),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              CupertinoDialogAction(
                child: Text('已认真阅读并同意'),
                onPressed: () {
                  setState(() {
                    _isSelected = true;
                  });
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });

    if (result) {
      await setPolicyAgreed();
      setState(() {
        _isSelected = true;
      });
    } else {
      setState(() {
        _isSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: CommonUtil.screenW(),
              width: CommonUtil.screenW(),
              child: Container(
                width: 0.85 * CommonUtil.screenW(),
                height: 0.85 * CommonUtil.screenW(),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/result.jpg"))),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    child: RawMaterialButton(
                      onPressed: () async {
                        if (_isSelected) {
                          await setPolicyAgreed();
                          print("点击了按钮");
                          // wechatAuth();
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) {
                            return MainPage();
                          }), (route) => false);
                          // Navigator.pushAndRemoveUntil(context, newRoute, (route) => false)(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return MainPage();
                          // }));
                        } else {
                          Fluttertoast.showToast(
                              msg: "请先阅读并同意用户隐私协议",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.orange,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      elevation: 2.0,
                      fillColor: Colors.white,
                      child: Icon(
                        Icons.arrow_forward,
                        size: 35.0,
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text("进入"),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: getRadio(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRadio() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: InkWell(
              onTap: () {
                setState(() {
                  if (_isSelected) {
                    _isSelected = false;
                  } else {
                    _isSelected = true;
                  }
                });
              },
              child: Icon(
                Icons.check_circle_outline,
                size: 22,
                color: _isSelected ? Colors.blue : Colors.grey,
              ),
            )),
            Container(
              child: Text(
                "我已阅读并同意" + CommonUtil.appName,
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Container(
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) {
                    return PolicyPage(
                      withTitle: true,
                    );
                  }));
                },
                child: Text(
                  "《隐私政策》",
                  style: TextStyle(color: Colors.blue, fontSize: fontSize),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "以及",
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Container(
              child: InkWell(
                onTap: () {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("用户须知"),
                          content: Container(
                            width: 200,
                            child: Text(
                                "  此APP为本人依据神经网络(开源)所做的个人项目。\n  所有数据训练集也为神经网络生成，无任何侵犯他人隐私或者肖像权行为存在。"),
                          ),
                          actions: [
                            CupertinoButton(
                                child: Text("确定"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                          ],
                        );
                      });
                },
                child: Text(
                  "《其它说明》",
                  style: TextStyle(color: Colors.blue, fontSize: fontSize),
                ),
              ),
            ),
          ],
        )
      ],
    );
    // child: Text("我已阅读并同意《职小侠用户隐私协议》"),
  }

  @override
  void afterFirstLayout(BuildContext context) {
    checkPolicyAgreed().then((value) {
      if (value) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return MainPage();
        }), (route) => false);
      }
    });
  }
}
