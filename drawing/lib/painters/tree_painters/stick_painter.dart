import 'package:drawing/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TreeStickPainter extends CustomPainter {
  TreeStick treeStick;

  TreeStickPainter({required this.treeStick});

  @override
  void paint(Canvas canvas, Size size) {
    var stick = Paint()
      ..strokeWidth = treeStick.width_
      ..strokeCap = StrokeCap.round
      ..color = treeStick.stickColor_
      ..style = PaintingStyle.fill;

    canvas.drawLine(treeStick.offset, treeStick.endOffset, stick);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
