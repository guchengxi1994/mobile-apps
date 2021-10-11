import 'package:drawing/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TreePainter extends CustomPainter {
  List objects;
  // int layers;
  TreePainter({required this.objects});

  @override
  void paint(Canvas canvas, Size size) {
    if (objects.isNotEmpty) {
      for (var i in objects) {
        // if (i.runtimeType == int) {}
        if (i.runtimeType == TreeRoot) {
          var stick = Paint()
            ..strokeWidth = i.width_
            ..strokeCap = StrokeCap.round
            ..color = i.rootColor_
            ..style = PaintingStyle.fill;
          canvas.drawLine(i.offset, i.endOffset, stick);
        }

        if (i.runtimeType == TreeStick) {
          var stick = Paint()
            ..strokeWidth = i.width_
            ..strokeCap = StrokeCap.round
            ..color = i.stickColor_
            ..style = PaintingStyle.fill;
          canvas.drawLine(i.offset, i.endOffset, stick);
        }

        if (i.runtimeType == TreeLeaf) {
          var leaf = Paint()
            ..strokeWidth = i.height_
            ..strokeCap = StrokeCap.round
            ..color = i.leafColor_
            ..style = PaintingStyle.fill;
          var startDx = i.offset.dx;
          var startDy = i.offset.dy;
          var endDx = i.endOffset.dx;
          var endDy = i.endOffset.dy;

          if (i.shadow_) {
            var leafShadow = Paint()
              ..strokeWidth = i.height_
              ..strokeCap = StrokeCap.round
              ..color = Colors.grey[400]!
              ..style = PaintingStyle.fill;
            var _offset1 = Offset(startDx + 1.5, startDy + 1.5);
            var _offset2 = Offset(endDx + 1.5, endDy + 1.5);
            canvas.drawArc(Rect.fromPoints(_offset1, _offset2), 0.0, 5.0, true,
                leafShadow);
          }

          canvas.drawArc(
              Rect.fromPoints(Offset(startDx, startDy), Offset(endDx, endDy)),
              0.0,
              5.0,
              true,
              leaf);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
