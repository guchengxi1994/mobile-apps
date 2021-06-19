import 'package:flutter/widgets.dart';

class VerticalText extends StatelessWidget {
  final String text;

  const VerticalText(this.text);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 30,
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      children: text
          .split("")
          .map((string) => Text(string,
              style: TextStyle(fontSize: 22, fontFamily: "MaShanZheng")))
          .toList(),
    );
  }
}
