import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_turtle/flutter_turtle.dart';

/// An example from https://www.calormen.com/jslogo/
class TreePage extends StatefulWidget {
  @override
  _TreePageState createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  double getRadius(double factor) {
    double a = Random().nextDouble() * 1.5 * factor;
    if (a > 10) {
      return a;
    } else {
      return 10;
    }
  }

  late double r1, r2, r3;

  double n = 128;

  double get a {
    return Random().nextDouble() * 15 + 10;
  }

  double get b {
    return Random().nextDouble() * 15 + 10;
  }

  double getD(double length) {
    return length * (Random().nextDouble() * 0.25 + 0.7);
  }

  @override
  void initState() {
    super.initState();
    r1 = getRadius(20);
    r2 = getRadius(30);
    r3 = getRadius(40);
  }

  @override
  Widget build(BuildContext context) {
    var commands = [
      SetMacro('tree', [
        IfElse((_) => _['size'] < 5.0, [
          Forward((_) => _['size']),
          // Stop(),
          // Back((_) => 140.0),
        ], [
          // Back((_) => 140.0),
          Forward((_) => (_['size'] ~/ 3).toDouble()),
          Left((_) => r1),
          RunMacro(
            'tree',
            (_) => {'size': ((_['size'] * 2 ~/ 3)).toDouble()},
          ),
          Right((_) => r1),
          Forward((_) => (_['size'] ~/ 6).toDouble()),
          Right((_) => r1),
          RunMacro(
            'tree',
            (_) => {'size': (_['size'] / 2).toDouble()},
          ),
          Left((_) => r1),
          Forward((_) => (_['size'] ~/ 3).toDouble()),
          Right((_) => r1),
          RunMacro(
            'tree',
            (_) => {'size': (_['size'] / 2).toDouble()},
          ),
          Left((_) => r1),
          Forward((_) => (_['size'] ~/ 6).toDouble()),
          Back((_) => _['size']),
        ])
      ]),
      Back((_) => 140.0),
      PenDown(),
      RunMacro('tree', (_) => {'size': 280.0, 'n': 5}),
      PenUp(),
    ];

    var _a = a;
    var _b = b;

    var commonds2 = [
      // PenDown(),
      SetMacro('tree', [
        IfElse((_) => _['n'] > 0, [
          Right((_) => _b),
          Forward((_) => 20),
          RunMacro('tree', (_) => {'n': _['n'] - 1, 'l': getD(_['l'])}),
          Left((_) => _b + _a),
          Forward((_) => 20),
          RunMacro('tree', (_) => {'n': _['n'] - 1, 'l': getD(_['l'])}),
          Right((_) => _a),
          Forward((_) => 20),
        ], [
          Right((_) => 90),
          SetColor((_) =>
              Color.fromARGB(1, n.ceil(), (n * 0.8).ceil(), (n * 0.8).ceil())),
          Forward((_) => 10),
          Left((_) => 90),
          Forward((_) => 10),
        ])
      ]),
      PenDown(),
      RunMacro('tree', (_) => {'n': 12, 'l': 100}),
      PenUp(),
    ];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Tree'),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              textColor: Colors.white,
              onPressed: () => setState(() {
                r1 = getRadius(20);
                r2 = getRadius(30);
                r3 = getRadius(40);
              }),
              child: const Text('Run'),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              AnimatedTurtleView(
                child: const SizedBox(width: double.infinity, height: 600),
                commands: commonds2,
              )
            ])));
  }
}
