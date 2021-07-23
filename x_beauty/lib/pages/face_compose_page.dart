part of './main_page.dart';

class FaceComposePage extends StatefulWidget {
  FaceComposePage({Key? key}) : super(key: key);

  @override
  _FaceComposePageState createState() => _FaceComposePageState();
}

class _FaceComposePageState extends State<FaceComposePage> {
  final buttonStrs = ["选择脸型", "选择眉毛", "选择眼睛", "选择嘴唇", "选择鼻子"];

  final imgpathStrs = [
    "assets/images/face/",
    "assets/images/eyebow/",
    "assets/images/eyes/",
    "assets/images/lips/",
    "assets/images/nose/"
  ];

  GlobalKey<_StackViewState> globalKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          CommonUtil.pageName3,
          style: TextStyle(fontFamily: "MaShanZheng"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                color: Colors.grey[300],
                margin: EdgeInsets.only(top: 20),
                height: CommonUtil.screenW(),
                width: CommonUtil.screenW(),
                child: StackView(
                  key: globalKey,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    getButton(0),
                    getButton(1),
                    getButton(2),
                    getButton(3),
                    getButton(4),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        globalKey.currentState!.clear();
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        child: Center(
                          child: Text(
                            "清空",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () async {
                        screenshotController
                            .capture(delay: Duration(microseconds: 10))
                            .then((value) async {
                          // ShowCapturedWidget(context, value!);
                          // print(value.runtimeType);
                          if (await Permission.storage.request().isGranted) {
                            var result =
                                await ImageGallerySaver.saveImage(value!);
                            // print(result);
                            Fluttertoast.showToast(
                                msg:
                                    "保存成功，可以使用" + CommonUtil.pageName2 + "进行转换",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            Fluttertoast.showToast(
                                msg: "需要同意权限才能使用功能",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }).catchError((onError) {
                          // print(onError);
                          Fluttertoast.showToast(
                              msg: "保存失败",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        child: Center(
                          child: Text(
                            "保存",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getButton(int index) {
    return InkWell(
      onTap: () {
        switch (index) {
          case 0:
            shouImageChosenDialog(0);
            break;
          case 1:
            shouImageChosenDialog(1);
            break;
          case 2:
            shouImageChosenDialog(2);
            break;
          case 3:
            shouImageChosenDialog(3);
            break;
          case 4:
            shouImageChosenDialog(4);
            break;
          default:
            shouImageChosenDialog(0);
            break;
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        alignment: Alignment.center,
        child: Text(
          buttonStrs[index],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(Radius.circular(28)),
          border: Border.all(width: 0, style: BorderStyle.none),
        ),
      ),
    );
  }

  void shouImageChosenDialog(int index) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("请选择"),
            content: getImgsView(index),
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("确定"))
            ],
          );
        });
  }

  Widget getImgsView(int index) {
    List<Widget> children = [];
    String _imgfolder = imgpathStrs[index];
    for (int i = 0; i < 16; i++) {
      var f = _imgfolder + i.toString() + ".png";
      children.add(getImgView(f, index));
    }

    return Container(
      width: 250,
      height: 250,
      color: Colors.lightBlue,
      child: Wrap(
        spacing: 10,
        runAlignment: WrapAlignment.spaceEvenly,
        children: children,
      ),
    );
  }

  Widget getImgView(String imgPath, int index) {
    return Material(
      child: InkWell(
        onTap: () {
          Widget w = Container(
            color: Colors.transparent,
            height: CommonUtil.screenW(),
            width: CommonUtil.screenH(),
            child: Image(
              fit: BoxFit.fill,
              image: AssetImage(imgPath),
            ),
          );
          globalKey.currentState!.appendWidget(w, index);
        },
        child: Container(
          width: 50,
          height: 50,
          child: Image(
            image: AssetImage(imgPath),
          ),
        ),
      ),
    );
  }
}

class StackView extends StatefulWidget {
  StackView({Key? key}) : super(key: key);

  @override
  _StackViewState createState() => _StackViewState();
}

class _StackViewState extends State<StackView> {
  List<Widget> stackChildren = [
    Container(),
    Container(),
    Container(),
    Container(),
    Container()
  ];

  void appendWidget(Widget w, int index) {
    setState(() {
      this.stackChildren.removeAt(index);
      this.stackChildren.insert(index, w);
    });
  }

  void clear() {
    setState(() {
      stackChildren = [
        Container(),
        Container(),
        Container(),
        Container(),
        Container()
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: stackChildren,
    );
  }
}
