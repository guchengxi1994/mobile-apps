part of 'package:password_store_app/pages/main/view/main_page.dart';

class ScanMainPage extends StatelessWidget {
  const ScanMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => mainBloc_..add(DataFetched()),
      child: ScanPage(),
    );
    // return ScanPage();
  }
}

class ScanPage extends StatefulWidget {
  ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  ScanController controller = ScanController();
  String qrcode = 'unknow';
  late MainBloc _mainBloc;
  bool? _changed;

  @override
  void initState() {
    super.initState();
    _mainBloc = context.read<MainBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(builder: (context, state) {
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          centerTitle: true,
          title: Text("Scan",
              style: TextStyle(color: Colors.white, fontFamily: "Pangolin")),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  height: CommonUtil.screenW() * 0.95,
                  width: CommonUtil.screenW() * 0.95,
                  child: ScanView(
                    controller: controller,
                    scanAreaScale: 0.8,
                    scanLineColor: Colors.green.shade400,
                    onCapture: (data) async {
                      // print("===================");
                      // print(data);
                      // print("===================");
                      try {
                        UserData userData =
                            UserData.fromJson(json.decode(data));
                        var res = showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text("信息校验"),
                                content: Center(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("App名:"),
                                          Text(userData.appname.toString()),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("用户名:"),
                                          Text(userData.userId.toString()),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Code:"),
                                          Expanded(
                                              child: Text(userData.userPasscode
                                                  .toString())),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text('取消'),
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      _changed = false;
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: Text('确定'),
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      userData.rid = null;
                                      _mainBloc
                                          .add(DataAdded(userData: userData));

                                      _changed = true;
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      } catch (e) {
                        print(e);
                        Fluttertoast.showToast(
                            msg: "无法解析数据",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  width: CommonUtil.screenW() * 0.9,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(_changed);
                      },
                      child: Text("退出")),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  width: CommonUtil.screenW() * 0.9,
                  child: ElevatedButton(
                      onPressed: () {
                        controller.resume();
                      },
                      child: Text("重试")),
                ),
              ),
            ],
          ),
        ),
      ));
    });
  }
}
