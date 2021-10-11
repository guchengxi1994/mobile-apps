import 'dart:math';

import 'package:flutter/material.dart';

import '../common.dart';

class TreeStick {
  /// id
  int id;

  /// 位置
  final Offset offset;

  /// 角度
  double? angle;

  /// 颜色
  Color? stickColor;

  /// 长度
  double? length;

  /// 是不是枝条
  bool isEnd;

  /// 宽度
  double? width;

  /// 子ids
  // List<int> childIds;

  TreeStick({
    this.angle,
    this.length,
    this.stickColor,
    this.width,
    required this.offset,
    required this.isEnd,
    required this.id,
  });

  Color get stickColor_ => stickColor ?? Colors.brown[300]!;

  // double get width_ => width ?? (Random().nextInt(20) + 15.0);
  double get width_ {
    width ??= 20;
    return width!;
  }

  // double get length_ => length ?? (Random().nextInt(100) + 50.0);
  double get length_ {
    length ??= Random().nextInt(100) + 100.0;
    return width!;
  }

  double get angle_ {
    angle ??= Random().nextDouble() * 180 - 90;
    return angle!;
  }

  Offset get endOffset {
    double startX = offset.dx;
    double startY = offset.dy;

    double endX = startX + cos(angle_ * rate) * width_;
    double endY = startY + sin(angle_ * rate) * width_;

    return Offset(endX, endY);
  }
}
