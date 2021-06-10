import 'package:flutter/material.dart';
import 'dart:math';

class ColorUtil {
  static Color getDynamicColor({int colorType = 0}) {
    /// 0 for rg ,1 for gb
    if (colorType == 0) {
      return Color.fromRGBO(Random().nextInt(128) + 128,
          Random().nextInt(128) + 128, Random().nextInt(128), 1);
    } else {
      return Color.fromRGBO(Random().nextInt(128), Random().nextInt(128) + 128,
          Random().nextInt(128) + 128, 1);
    }
  }

  static Color getDynamicWarmColor() {
    return getDynamicColor(colorType: 0);
  }

  static Color getDynamicColdColor() {
    return getDynamicColor(colorType: 1);
  }

  static final Color colorEnd = Color.fromRGBO(255, 255, 255, 1);
}
