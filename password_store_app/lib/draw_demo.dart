import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

class Draw extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

const Color _black = Color.fromRGBO(5, 5, 5, 1.0);

class _DrawState extends State<Draw> {
  ScreenshotController screenshotController = ScreenshotController();
  GlobalKey<SignatureState> signatureKey = GlobalKey(); // 使跨组件访问状态
  Color selectedColor = _black;
  Color pickerColor = _black;
  double strokeWidth = 3.0;
  List<DrawingPoints?> points = [];
  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    _black
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "D r a w i n g",
          style: TextStyle(fontFamily: "Pangolin"),
        ),
        backgroundColor: Colors.blue,
        leading: InkWell(
          child: Container(
            child: Icon(Icons.chevron_left),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.grey,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.greenAccent),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.album),
                          onPressed: () {
                            selectedColor = pickerColor;
                            setState(() {
                              if (selectedMode == SelectedMode.StrokeWidth)
                                showBottomList = !showBottomList;
                              selectedMode = SelectedMode.StrokeWidth;
                            });
                          }),
                      IconButton(
                          icon: Icon(Icons.opacity),
                          onPressed: () {
                            setState(() {
                              if (selectedMode == SelectedMode.Opacity)
                                showBottomList = !showBottomList;
                              selectedMode = SelectedMode.Opacity;
                            });
                          }),
                      IconButton(
                          icon: Icon(Icons.color_lens),
                          onPressed: () {
                            setState(() {
                              if (selectedMode == SelectedMode.Color)
                                showBottomList = !showBottomList;
                              selectedMode = SelectedMode.Color;
                            });
                          }),
                      IconButton(
                          icon: Icon(Icons.clear_all),
                          onPressed: () {
                            setState(() {
                              selectedColor = Colors.white;
                            });
                          }),
                      IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              showBottomList = false;
                              // points.clear();
                              signatureKey.currentState!.clearPoints();
                              print("....");
                            });
                          }),
                      IconButton(
                          icon: Icon(Icons.save),
                          onPressed: () async {
                            screenshotController
                                .capture(delay: Duration(microseconds: 10))
                                .then((value) async {
                              ShowCapturedWidget(context, value!);
                              print(value.runtimeType);
                              if (await Permission.storage
                                  .request()
                                  .isGranted) {
                                var result =
                                    await ImageGallerySaver.saveImage(value);
                                print(result);
                              }
                            }).catchError((onError) {
                              print(onError);
                            });
                            // ui.Image renderedImage =
                            //     await signatureKey.currentState!.rendered;
                            // print(renderedImage.runtimeType);
                            // // Directory appDocDir =
                            // //     await getApplicationDocumentsDirectory();
                            // // String appDocPath = appDocDir.path;
                            // var pngBytes = await renderedImage.toByteData(
                            //     format: ui.ImageByteFormat.png);
                            // Uint8List pngb = pngBytes!.buffer.asUint8List();
                            // // String bs64 = base64Encode(pngb);
                            // // print(bs64);
                            // if (await Permission.storage.request().isGranted) {
                            //   var result =
                            //       await ImageGallerySaver.saveImage(pngb);
                            //   print(result);
                            // }
                          }),
                    ],
                  ),
                  Visibility(
                    child: (selectedMode == SelectedMode.Color)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: getColorList(),
                          )
                        : Slider(
                            value: (selectedMode == SelectedMode.StrokeWidth)
                                ? strokeWidth
                                : opacity,
                            max: (selectedMode == SelectedMode.StrokeWidth)
                                ? 50.0
                                : 1.0,
                            min: 0.0,
                            onChanged: (val) {
                              setState(() {
                                if (selectedMode == SelectedMode.StrokeWidth)
                                  strokeWidth = val;
                                else
                                  opacity = val;
                              });
                            }),
                    visible: showBottomList,
                  ),
                ],
              ),
            )),
      ),

      body: Screenshot(
        controller: screenshotController,
        child: Signature(
          selectedColor: selectedColor,
          key: signatureKey,
        ),
      ),

      // body: GestureDetector(
      //   onPanUpdate: (details) {
      //     setState(() {
      //       RenderBox renderBox = context.findRenderObject() as RenderBox;
      //       points.add(DrawingPoints(
      //           points: renderBox.globalToLocal(details.globalPosition),
      //           paint: Paint()
      //             ..strokeCap = strokeCap
      //             ..isAntiAlias = true
      //             ..color = selectedColor.withOpacity(opacity)
      //             ..strokeWidth = strokeWidth));
      //     });
      //   },
      //   onPanStart: (details) {
      //     setState(() {
      //       RenderBox renderBox = context.findRenderObject() as RenderBox;
      //       points.add(DrawingPoints(
      //           points: renderBox.globalToLocal(details.globalPosition),
      //           paint: Paint()
      //             ..strokeCap = strokeCap
      //             ..isAntiAlias = true
      //             ..color = selectedColor.withOpacity(opacity)
      //             ..strokeWidth = strokeWidth));
      //     });
      //   },
      //   onPanEnd: (details) {
      //     setState(() {
      //       points.add(null);
      //     });
      //   },
      //   child: CustomPaint(
      //     size: Size.infinite,
      //     painter: DrawingPainter(
      //       pointsList: points,
      //     ),
      //   ),
      // ),
    );
  }

  getColorList() {
    List<Widget> listWidget = [];
    for (Color color in colors) {
      listWidget.add(colorCircle(color));
    }
    Widget colorPicker = GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (color) {
                    pickerColor = color;
                  },
                  pickerAreaHeightPercent: 0.8,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() => selectedColor = pickerColor);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.red, Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
      ),
    );
    listWidget.add(colorPicker);
    return listWidget;
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          color: color,
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});
  List<DrawingPoints?>? pointsList;
  List<Offset>? offsetPoints = [];
  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawColor(Colors.pinkAccent, BlendMode.srcIn);
    for (int i = 0; i < pointsList!.length - 1; i++) {
      if (pointsList![i] != null && pointsList![i + 1] != null) {
        canvas.drawLine(pointsList![i]!.points!, pointsList![i + 1]!.points!,
            pointsList![i]!.paint!);
      } else if (pointsList![i] != null && pointsList![i + 1] == null) {
        offsetPoints!.clear();
        offsetPoints!.add(pointsList![i]!.points!);
        offsetPoints!.add(Offset(pointsList![i]!.points!.dx + 0.1,
            pointsList![i]!.points!.dy + 0.1));
        canvas.drawPoints(
            ui.PointMode.points, offsetPoints!, pointsList![i]!.paint!);
      }
    }
  }

  Future<ui.Image> get rendered {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    DrawingPainter painter = DrawingPainter(pointsList: this.pointsList);
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    var size = mediaQuery.size;
    painter.paint(canvas, Size.infinite);
    return recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint? paint;
  Offset? points;
  DrawingPoints({this.points, this.paint});
}

enum SelectedMode { StrokeWidth, Opacity, Color }

class Signature extends StatefulWidget {
  Color selectedColor;

  Signature({Key? key, required this.selectedColor}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignatureState();
  }
}

class SignatureState extends State<Signature> {
  // List<Offset> _points = <Offset>[];
  List<DrawingPoints?> points = [];
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  double strokeWidth = 3.0;

  Future<ui.Image> get rendered {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    // canvas.drawColor(Colors.red, BlendMode.srcIn);
    DrawingPainter painter = DrawingPainter(pointsList: points);
    var size = context.size;
    painter.paint(canvas, size!);
    return recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              points.add(DrawingPoints(
                  points: renderBox.globalToLocal(details.globalPosition),
                  paint: Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = widget.selectedColor.withOpacity(opacity)
                    ..strokeWidth = strokeWidth));
            });
          },
          onPanStart: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              points.add(DrawingPoints(
                  points: renderBox.globalToLocal(details.globalPosition),
                  paint: Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = widget.selectedColor.withOpacity(opacity)
                    ..strokeWidth = strokeWidth));
            });
          },
          onPanEnd: (DragEndDetails details) {
            setState(() {
              points.add(null);
            });
          },
          child: CustomPaint(
            painter: DrawingPainter(pointsList: points),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }

  // clearPoints method used to reset the canvas
  // method can be called using
  //   key.currentState.clearPoints();
  void clearPoints() {
    setState(() {
      points.clear();
    });
  }
}

Future<dynamic> ShowCapturedWidget(
    BuildContext context, Uint8List capturedImage) {
  return showDialog(
    useSafeArea: false,
    context: context,
    builder: (context) => Scaffold(
      appBar: AppBar(
        title: Text("Captured widget screenshot"),
      ),
      body: Center(
          child: capturedImage != null
              ? Image.memory(capturedImage)
              : Container()),
    ),
  );
}
