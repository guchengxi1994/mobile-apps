import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_turtle/flutter_turtle.dart';

class TreePaintingWidget extends StatefulWidget {
  TreePaintingWidget(
      {Key? key, required this.withController, this.treeHeight, this.iteration})
      : super(key: key);

  final bool withController;

  /// trunk height
  final double? treeHeight;

  /// less than 10 recommended
  final int? iteration;

  @override
  _TreePaintingWidgetState createState() => _TreePaintingWidgetState();
}

class _TreePaintingWidgetState extends State<TreePaintingWidget>
    with SingleTickerProviderStateMixin {
  late bool isRandom;
  AnimationController? _controller;

  Color get randomColor => Color.fromARGB(
      255, Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));

  @override
  void initState() {
    super.initState();
    isRandom = !widget.withController;
    if (widget.withController) {
      _controller = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
        value: 0.0,
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  double get a {
    return Random().nextDouble() * 15 + 10;
  }

  double get b {
    return Random().nextDouble() * 15 + 10;
  }

  @override
  Widget build(BuildContext context) {
    var commonds;
    var _a = a;
    var _b = b;
    Color _color = const Color.fromARGB(255, 25, 25, 25);
    if (!widget.withController) {
      commonds = [
        SetMacro('leaf', [
          PenUp(),
          Forward((_) => _['distance']),
          PenDown(),
          Right((_) => 90),
          SetColor((_) => randomColor),
          Repeat((_) => 180, [Forward((_) => 0.1), Right((_) => 3)]),
          Left((_) => 90),
          PenUp(),
          Back((_) => _['distance'])
        ]),

        SetMacro('tree', [
          PenDown(),
          SetColor((_) => _color),
          SetStrokeWidth((_) => _['n'] / 4),
          Forward((_) => _['l'] * 1.0),
          IfElse((_) => _['n'] > 0, [
            Right((_) => _b),
            RunMacro(
                'tree',
                (_) => {
                      'n': _['n'] - 1,
                      'l': _['l'] * (Random().nextDouble() * 0.35 + 0.6),
                    }),
            Left((_) => _a + _b),
            RunMacro(
                'tree',
                (_) => {
                      'n': _['n'] - 1,
                      'l': _['l'] * (Random().nextDouble() * 0.35 + 0.6),
                    }),
            Right((_) => _a),
          ], [
            Right((_) => 90),
            SetColor((_) => Colors.green),
            // Forward((_) => 3),
            Repeat((_) => 180, [Forward((_) => 0.1), Right((_) => 3)]),
            Left((_) => 90),

            If((_) => Random().nextDouble() > 0.7, [
              RunMacro(
                  'leaf',
                  (_) => {
                        'distance': 800 * Random().nextDouble() * 0.5 +
                            400 * Random().nextDouble() * 0.3 +
                            200 * Random().nextDouble() * 0.2
                      })
            ]),
          ]),
          PenUp(),
          Back((_) => _['l'])
        ]),

        SetMacro('tree2', [
          PenDown(),
          SetColor((_) => Colors.red),
          Forward((_) => _['l']),
        ]),

        // Left((_) => 90),
        PenUp(),
        Back((_) => 300),
        RunMacro(
            'tree',
            (_) =>
                {'n': widget.iteration ?? 10, 'l': widget.treeHeight ?? 100.0}),
      ];
    }

    return Container();
  }
}

class TreePaint extends StatelessWidget {
  const TreePaint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TreePaintingWidget(
      withController: false,
    );
  }
}
