import 'dart:math';

import 'package:flutter/material.dart';

class TreeRoot {
  /// 子 ID
  List<int> childIds;

  /// 颜色
  Color? rootColor;

  /// 宽度
  double? width;

  /// 高度
  double? heigit;

  /// 位置
  final Offset offset;

  TreeRoot(
      {this.rootColor,
      this.width,
      this.heigit,
      required this.offset,
      required this.childIds});

  Color get rootColor_ => rootColor ?? Colors.brown;

  double get width_ => width ?? (Random().nextInt(40) + 15.0);

  double get heigit_ {
    heigit ??= (Random().nextInt(100) + 50.0);
    return heigit!;
  }

  Offset get endOffset {
    double startX = offset.dx;
    double startY = offset.dy;

    double endX = startX;
    double endY = startY + heigit_;

    return Offset(endX, endY);
  }
}
