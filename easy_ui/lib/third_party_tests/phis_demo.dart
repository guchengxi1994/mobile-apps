import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

const _bannerWidth = 300.0;
const _margin = 75.0;

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = ScrollController();

  final List<int> pages = List.generate(4, (index) => index);

  ScrollPhysics _physics;

  List<String> imageList = [
    "assets/images/0026.jpg",
    "assets/images/0032.jpg",
    "assets/images/0034.jpg",
    "assets/images/0036.jpg",
  ];

  double allLength;

  //定时器自动轮播
  Timer _timer;

  double _gap = _bannerWidth + _margin;

  //当前显示的索引
  int currentIndex = 0;

  void startTimer() {
    //间隔两秒时间
    _timer = new Timer.periodic(Duration(milliseconds: 4000), (value) {
      print("定时器");
      currentIndex++;
      //触发轮播切换
      // _controller.animateToPage(currentIndex,
      //     duration: Duration(milliseconds: 500), curve: Curves.ease);

      if (currentIndex < imageList.length) {
        _controller.animateTo(currentIndex * _gap,
            duration: Duration(milliseconds: 1000), curve: Curves.linear);
      } else {
        currentIndex = 0;
        _controller.animateTo(0,
            duration: Duration(milliseconds: 500), curve: Curves.linear);
      }

      //刷新
      // setState(() {});
    });
  }

  buildPageViewItemWidget(int index) {
    return Container(
      width: _bannerWidth,
      margin: index == imageList.length - 1
          ? EdgeInsets.only(right: _margin * 3)
          : EdgeInsets.only(right: _margin),
      height: 200,
      child: Image.asset(
        imageList[index % imageList.length],
        fit: BoxFit.fill,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    allLength = imageList.length * (_margin + _bannerWidth);

    // _controller.addListener(() {
    //   if (_controller.position.haveDimensions && _physics == null) {
    //     setState(() {
    //       var dimension =
    //           _controller.position.maxScrollExtent / (pages.length - 1);
    //       _physics = CustomScrollPhysics(itemDimension: dimension);
    //     });
    //   }
    // });

    _controller.addListener(() {
      currentIndex = (_controller.offset / _gap).floor();
    });

    ///当前页面绘制完第一帧后回调
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _controller,
          // physics: _physics,
          // physics: NeverScrollableScrollPhysics(),
          itemCount: imageList.length,
          itemBuilder: (context, index) => buildPageViewItemWidget(index),
        ),
      ),
    );
  }

  Color get randomColor =>
      Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);
}

class CustomScrollPhysics extends ScrollPhysics {
  final double itemDimension;

  CustomScrollPhysics({this.itemDimension, ScrollPhysics parent})
      : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomScrollPhysics(
        itemDimension: itemDimension, parent: buildParent(ancestor));
  }

  double _getPage(ScrollPosition position) {
    return position.pixels / itemDimension;
  }

  double _getPixels(double page) {
    return page * itemDimension;
  }

  double _getTargetPixels(
      ScrollPosition position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    return _getPixels(page.roundToDouble());
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent))
      return super.createBallisticSimulation(position, velocity);
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels)
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
