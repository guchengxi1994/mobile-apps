import 'package:bluetooth_unlock_windows/util.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BleDataModel bleDataModel = BleDataModel();

  @override
  void initState() {
    super.initState();
    initBle();
    startBle();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }
}

main(List<String> args) {
  runApp(new MaterialApp(
    home: MainPage(),
  ));
}
