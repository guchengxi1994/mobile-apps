import 'package:flutter/material.dart';

class TreePainter extends CustomPainter {
  List objects;
  int layers;
  TreePainter({required this.objects, required this.layers});

  @override
  void paint(Canvas canvas, Size size) {
    if (objects.isNotEmpty) {
      for (var i in objects) {
        if (i.runtimeType == int) {}
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
