import 'package:drawing/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TreeLeafPainter extends CustomPainter {
  TreeLeaf treeLeaf;

  TreeLeafPainter({required this.treeLeaf});

  @override
  void paint(Canvas canvas, Size size) {
    var leaf = Paint()
      ..strokeWidth = treeLeaf.height_
      ..strokeCap = StrokeCap.round
      ..color = treeLeaf.leafColor_
      ..style = PaintingStyle.fill;

    // canvas.drawLine(treeLeaf.offset, treeLeaf.endOffset, leaf);

    var startDx = treeLeaf.offset.dx;
    var startDy = treeLeaf.offset.dy;
    var endDx = treeLeaf.endOffset.dx;
    var endDy = treeLeaf.endOffset.dy;

    if (treeLeaf.shadow_) {
      var leafShadow = Paint()
        ..strokeWidth = treeLeaf.height_
        ..strokeCap = StrokeCap.round
        ..color = Colors.grey[400]!
        ..style = PaintingStyle.fill;
      var _offset1 = Offset(startDx + 1.5, startDy + 1.5);
      var _offset2 = Offset(endDx + 1.5, endDy + 1.5);
      canvas.drawArc(
          Rect.fromPoints(_offset1, _offset2), 0.0, 5.0, true, leafShadow);
    }

    canvas.drawArc(
        Rect.fromPoints(Offset(startDx, startDy), Offset(endDx, endDy)),
        0.0,
        5.0,
        true,
        leaf);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
