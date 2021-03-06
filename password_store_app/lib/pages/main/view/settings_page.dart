part of 'package:password_store_app/pages/main/view/main_page.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _futureVersionBuilder;
  late SettingsBloc _settingsBloc;
  bool setted = false;
  bool available = false;
  bool _loading = false;

  @override
  void initState() {
    _settingsBloc = context.read<SettingsBloc>();
    _futureVersionBuilder = getAppInfo();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Settings",
              style: TextStyle(color: Colors.white, fontFamily: "Pangolin")),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment(0, -1),
                  // height: 350,
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
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      FutureBuilder(
                        future: _futureVersionBuilder,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
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
                                "????.????.????",
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
                Container(
                  width: CommonUtil.screenW(),
                  margin: EdgeInsets.only(top: 30),
                  child: Container(
                    width: CommonUtil.screenW() * 0.9,
                    alignment: Alignment(0, 0),
                    child: Column(
                      children: [
                        InkWell(
                          child: Container(
                            width: CommonUtil.screenW() * 0.9,
                            child: ListTile(
                              title: Text("?????????"),
                              trailing: Icon(Icons.chevron_right,
                                  color: Colors.grey[200]),
                            ),
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: Colors.grey[200]!),
                                    bottom:
                                        BorderSide(color: Colors.grey[200]!))),
                          ),
                          onTap: () async {
                            const url = 'https://github.com/guchengxi1994';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "??????????????????",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                        ),
                        // InkWell(
                        //   child: Container(
                        //     width: CommonUtil.screenW() * 0.9,
                        //     child: ListTile(
                        //       title: Text("??????????????????"),
                        //       trailing: Icon(Icons.chevron_right,
                        //           color: Colors.grey[200]),
                        //     ),
                        //     decoration: BoxDecoration(
                        //         border: Border(
                        //             top: BorderSide(color: Colors.grey[200]!),
                        //             bottom:
                        //                 BorderSide(color: Colors.grey[200]!))),
                        //   ),
                        //   onTap: () async {
                        //     Navigator.of(context).pushNamed(Routers.qrscan);
                        //   },
                        // ),
                        InkWell(
                          child: Container(
                            width: CommonUtil.screenW() * 0.9,
                            child: ListTile(
                              title: Text("????????????"),
                              trailing: Icon(Icons.chevron_right,
                                  color: Colors.grey[200]),
                            ),
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: Colors.grey[200]!),
                                    bottom:
                                        BorderSide(color: Colors.grey[200]!))),
                          ),
                          onTap: () async {
                            setState(() {
                              _loading = true;
                            });
                            Directory appDocDir =
                                await getApplicationDocumentsDirectory();
                            String appDocPath = appDocDir.path;

                            print(appDocPath);
                            final _path = appDocPath + "/" + "passcode.txt";
                            File f = File(_path);

                            List<UserData>? us = await fetchUserData();
                            if (null != us) {
                              for (var i in us) {
                                // print(json.encode(i.toJson()));
                                f.writeAsString(json.encode(i.toJson()) + '\n',
                                    mode: FileMode.append);
                              }
                              Fluttertoast.showToast(
                                  msg: "????????????",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "????????????????????????",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }

                            setState(() {
                              _loading = false;
                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            width: CommonUtil.screenW() * 0.9,
                            child: ListTile(
                              title: Text("????????????"),
                              trailing: Icon(Icons.chevron_right,
                                  color: Colors.grey[200]),
                            ),
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: Colors.grey[200]!),
                                    bottom:
                                        BorderSide(color: Colors.grey[200]!))),
                          ),
                          onTap: () async {
                            Navigator.of(context)
                                .push(new MaterialPageRoute(builder: (context) {
                              return ImportWidget();
                            }));
                          },
                        ),
                        InkWell(
                          child: Container(
                            width: CommonUtil.screenW() * 0.9,
                            child: ListTile(
                              title: Text("App????????????"),
                              // trailing: Icon(Icons.chevron_right,
                              //     color: Colors.grey[200]),
                              trailing: Text(
                                  _settingsBloc.state.settings.toParamString()),
                            ),
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: Colors.grey[200]!),
                                    bottom:
                                        BorderSide(color: Colors.grey[200]!))),
                          ),
                          onTap: () async {
                            bool f2 = _settingsBloc.state.settings.pscAvailable;
                            bool f3 = _settingsBloc
                                .state.settings.fingerprintAvailable;
                            var result = await showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                    title: Text(
                                      "App????????????",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    children: [
                                      SimpleDialogOption(
                                        child: Text("1. ????????????????????? "),
                                        onPressed: () {
                                          Navigator.of(context).pop(1);
                                        },
                                      ),
                                      SimpleDialogOption(
                                        child: Text(
                                            "2. ???????????? " + (f2 ? "?????????" : "?????????")),
                                        onPressed: () async {
                                          if (!f2) {
                                            var _b = await showCupertinoDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CupertinoAlertDialog(
                                                    title: Text(
                                                      "???????????????????????????\n?????????????????????",
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          child: Text("??????"),
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  false)),
                                                      FlatButton(
                                                          child: Text("??????"),
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  true)),
                                                    ],
                                                  );
                                                });

                                            if (_b) {
                                              print("??????");
                                              setted =
                                                  await Navigator.of(context)
                                                      .pushNamed(Routers
                                                          .textCreate) as bool;
                                              // _settingsBloc.add(SettingsChanged(settings: UserSettings()));
                                              await setPscAvailable(true);
                                            } else {
                                              print("??????");
                                              setted = _settingsBloc
                                                  .state.settings.pscAvailable;
                                            }
                                          }
                                          // print("+++++++++++++++");
                                          // print(setted);
                                          // print(_settingsBloc
                                          //     .state.settings.pscAvailable);
                                          // print("+++++++++++++++");
                                          if (setted ||
                                              _settingsBloc.state.settings
                                                  .pscAvailable) {
                                            Navigator.of(context).pop(2);
                                          } else {
                                            Navigator.of(context).pop(1);
                                          }
                                        },
                                      ),
                                      SimpleDialogOption(
                                          child: Text("3. ???????????? " +
                                              (f3 ? "?????????" : "?????????")),
                                          onPressed: () async {
                                            if (!f3) {
                                              var _b =
                                                  await showCupertinoDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return CupertinoAlertDialog(
                                                          title: Text(
                                                            "???????????????????????????\n?????????????????????",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                                child:
                                                                    Text("??????"),
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context,
                                                                        false)),
                                                            FlatButton(
                                                                child:
                                                                    Text("??????"),
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context,
                                                                        true)),
                                                          ],
                                                        );
                                                      });

                                              if (_b) {
                                                print("??????");
                                                LocalAuthSingleton l =
                                                    LocalAuthSingleton();
                                                available = (await l
                                                        .getAvailableBiometrics())
                                                    .contains(BiometricType
                                                        .fingerprint);
                                              } else {
                                                // available = _settingsBloc
                                                //     .state
                                                //     .settings
                                                //     .fingerprintAvailable;
                                                print("??????");
                                              }
                                            }

                                            if (available) {
                                              Navigator.of(context).pop(3);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "?????????????????????",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 2,
                                                  backgroundColor: Colors.blue,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              Navigator.of(context).pop(1);
                                            }
                                          }),
                                    ],
                                  );
                                });

                            // print("===================");
                            // debugPrint(result.toString());
                            // debugPrint(_settingsBloc.state.settings.pscAvailable
                            //     .toString());
                            // debugPrint(available.toString());
                            // print("===================");
                            _settingsBloc.add(SettingsChanged(
                                settings: UserSettings(
                                    result,
                                    _settingsBloc
                                        .state.settings.gestureAvailable,
                                    setted ||
                                        _settingsBloc
                                            .state.settings.pscAvailable,
                                    available ||
                                        _settingsBloc.state.settings
                                            .fingerprintAvailable)));
                          },
                        ),
                        _settingsBloc.state.settings.pscAvailable
                            ? InkWell(
                                child: Container(
                                  width: CommonUtil.screenW() * 0.9,
                                  child: ListTile(
                                    title: Text("??????????????????"),
                                    trailing: Icon(Icons.chevron_right,
                                        color: Colors.grey[200]),
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.grey[200]!),
                                          bottom: BorderSide(
                                              color: Colors.grey[200]!))),
                                ),
                                onTap: () async {
                                  var changed = await Navigator.of(context)
                                      .pushNamed(Routers.textCreate) as bool;
                                  print(changed);
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
