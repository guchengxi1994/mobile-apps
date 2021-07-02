part of './main_page.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _futureVersionBuilder;

  @override
  void initState() {
    super.initState();
    _futureVersionBuilder = getAppInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings",
            style: TextStyle(color: Colors.white, fontFamily: "Pangolin")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment(0, -1),
              width: CommonUtil.screenW(),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(color: Colors.grey[200]!, blurRadius: 20.0)
                    ], borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Container(
                      width: 100,
                      height: 100,
                      child: Image.asset(
                        CommonUtil.appIcon,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      CommonUtil.appName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureBuilder(
                    future: _futureVersionBuilder,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            "Version:" + snapshot.data.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            "🤪.🤪.🤪",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            buildSettings(),
          ],
        ),
      ),
    );
  }

  Future<String> getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    // print(version);
    return version;
  }

  Widget buildSettings() {
    return Container(
        width: CommonUtil.screenW(),
        margin: EdgeInsets.only(top: 30),
        child: Container(
            width: CommonUtil.screenW() * 0.9,
            alignment: Alignment(0, 0),
            child: Column(children: [
              InkWell(
                child: Container(
                  width: CommonUtil.screenW() * 0.9,
                  child: ListTile(
                    title: Text("关于我"),
                    trailing:
                        Icon(Icons.chevron_right, color: Colors.grey[200]),
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.grey[200]!),
                          bottom: BorderSide(color: Colors.grey[200]!))),
                ),
                onTap: () async {
                  const url = 'https://github.com/guchengxi1994';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    Fluttertoast.showToast(
                        msg: "无法打开网页",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ),
              InkWell(
                child: Container(
                  width: CommonUtil.screenW() * 0.9,
                  child: ListTile(
                    title: Text("说明"),
                    trailing:
                        Icon(Icons.chevron_right, color: Colors.grey[200]),
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.grey[200]!),
                          bottom: BorderSide(color: Colors.grey[200]!))),
                ),
                onTap: () async {},
              ),
            ])));
  }
}
