/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-10-08 19:16:24
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-10-08 19:40:10
 */
import 'dart:math';

import 'package:flutter/material.dart';

import '../common.dart';

class TreeLeaf {
  /// id
  int id;

  /// 颜色
  Color? leafColor;

  /// 是否有阴影
  bool? shadow;

  /// 高度
  double? heigit;

  /// 宽度
  double? width;

  /// 角度
  double? angle;

  /// 位置
  final Offset offset;

  TreeLeaf(
      {this.angle,
      this.heigit,
      this.leafColor,
      this.shadow,
      this.width,
      required this.offset,
      required this.id});

  Color get leafColor_ => leafColor ?? Colors.amber;
  bool get shadow_ => shadow ?? false;
  double get width_ => width ?? (Random().nextInt(20) + 5.0);
  double get height_ => heigit ?? (Random().nextInt(20) + 5.0);
  double get angle_ => angle ?? Random().nextDouble() * 180 - 90;
  Offset get endOffset {
    double startX = offset.dx;
    double startY = offset.dy;

    double endX = startX + cos(angle_ * rate) * width_;
    double endY = startY + sin(angle_ * rate) * width_;

    return Offset(endX, endY);
  }
}
