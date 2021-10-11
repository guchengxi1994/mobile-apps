import 'package:flutter/material.dart';

class ShadowImageView extends StatefulWidget {
  ShadowImageView({Key? key}) : super(key: key);

  @override
  ShadowImageViewState createState() => ShadowImageViewState();
}

class ShadowImageViewState extends State<ShadowImageView> {
  Color shadowColor = Colors.grey;
  double radius = 20;

  changeRadius(double data) {
    setState(() {
      radius = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [BoxShadow(color: shadowColor, blurRadius: 20)],
          image:
              const DecorationImage(image: AssetImage('assets/images/1.jpg'))),
    );
  }
}
