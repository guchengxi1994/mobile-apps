import 'package:flutter/material.dart';
import 'package:turtledrawing/tests/color_chosen_test_page.dart';
import 'package:turtledrawing/tests/tree_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ColorPickerTestWidget(),
    );
  }
}
