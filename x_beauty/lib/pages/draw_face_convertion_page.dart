part of './main_page.dart';

class DrawfacePage extends StatefulWidget {
  @override
  DrawfaceState createState() => DrawfaceState();
}

class DrawfaceState extends State {
  var _imgPath;
  String? filename;
  bool _isConverted = false;
  bool _converting = false;
  final ImagePicker _picker = ImagePicker();
  String? _changedImage;

  // String stateStr = "";
  final platform = MethodChannel("face.convert");
  BasicMessageChannel _messageChannel =
      BasicMessageChannel("android.call", StandardMessageCodec());

  @override
  void initState() {
    super.initState();
    _messageChannel.setMessageHandler((message) async {
      if (null != message) {
        print(message.toString());
        setState(() {
          _changedImage = message;
          _converting = false;
        });
      }
      return "已收到";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          CommonUtil.pageName2,
          style: TextStyle(fontFamily: "MaShanZheng"),
        ),
      ),
      body: LoadingOverlay(
        isLoading: _converting,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50, bottom: 50),
                child: _ImageView(_imgPath),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        //设置四周边框
                        border: new Border.all(width: 1, color: Colors.red),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          // print("babalaka");
                          if (await Permission.storage.request().isGranted) {
                            var image = await _picker.getImage(
                                source: ImageSource.gallery);

                            setState(() {
                              _isConverted = false;
                              // stateStr = "";
                            });

                            if (null != image) {
                              setState(() {
                                print(image.path);
                                _imgPath = File(image.path);
                                filename = image.path;
                              });
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "需要同意权限才能使用功能",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: Text("选择"),
                      ),
                    ),
                    Container(
                      decoration: new BoxDecoration(
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        //设置四周边框
                        border: new Border.all(width: 1, color: Colors.red),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          print("kakabala");
                          // setState(() {
                          //   _isConverted = false;
                          //   // stateStr = "";
                          // });

                          // getResult(type: 1).then((value) {
                          //   print(value.runtimeType);
                          //   if (value.runtimeType == String) {
                          //     _changedImage = value;
                          //   }
                          // });
                          if (null != filename) {
                            setState(() {
                              _converting = true;
                            });

                            await getResult(type: 1);
                          } else {
                            Fluttertoast.showToast(
                                msg: "请先选择图片文件",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: Text("转换"),
                      ),
                    ),
                    Container(
                      decoration: new BoxDecoration(
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        //设置四周边框
                        border: new Border.all(width: 1, color: Colors.red),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          // print(_changedImage);
                          if (_changedImage != null) {
                            File imageData = File(_changedImage!);
                            List<int> imageBytes = imageData.readAsBytesSync();
                            String bs64 = base64Encode(imageBytes);
                            var bytes = Base64Decoder().convert(bs64);
                            var result =
                                await ImageGallerySaver.saveImage(bytes);
                            print(result);
                            print(result.runtimeType);
                            if (result == null || result['filePath'] == null) {
                              Fluttertoast.showToast(
                                  msg: "保存失败",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "保存图片成功",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "无法保存图片",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: Text("保存"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> getResult({required int type}) async {
    Map<String, Object> map = {"filename": filename!, "type": type};

    if (filename != null) {
      dynamic resultValue = await platform.invokeMethod("convert", map);
      // print(resultValue.runtimeType);
      setState(() {
        // _imgPath = File(resultValue);
        _isConverted = true;
      });
      if (resultValue.runtimeType == String) {
        return resultValue;
      } else {
        return null;
      }
    } else {
      Fluttertoast.showToast(
          msg: "请先选择图片文件",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      return null;
    }
  }

  Widget _ImageView(imgpath) {
    if (imgpath == null) {
      // return Center(
      //   child: Text("plz choose an image"),
      // );
      return Container(
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.blue)),
        height: 300,
        width: 300,
        child: Center(
          child: Text("请选择一张简笔画\n最好是正常一点的简笔画"),
        ),
      );
    } else {
      if (!_isConverted) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onLongPress: () async {
                print("long press");
                if (null != imgpath) {
                  File result = await _cropImage(imgpath) as File;
                  // print(result);
                  // print(result.path);
                  if (result != null) {
                    setState(() {
                      _imgPath = result;
                      filename = result.path;
                    });
                  }
                }
              },
              child: Container(
                height: 300,
                width: 300,
                child: Image.file(
                  imgpath,
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            _isConverted == false && imgpath != null
                ? Container(
                    margin: EdgeInsets.all(10),
                    child: Text("长按图像以裁剪图像"),
                  )
                : Container(),
          ],
        );
      } else {
        // return Container(
        //   child: BeforeAfter(
        //     beforeImage: Image.file(
        //       imgpath,
        //       width: 300,
        //       height: 300,
        //       fit: BoxFit.fill,
        //     ),
        //     afterImage: Image.file(
        //       File(_changedImage!),
        //       width: 300,
        //       height: 300,
        //       fit: BoxFit.fill,
        //     ),
        //     isVertical: false,
        //   ),
        // );

        if (null != _changedImage && _converting == false) {
          return Container(
            child: BeforeAfter(
              beforeImage: Image.file(
                imgpath,
                width: 300,
                height: 300,
                fit: BoxFit.fill,
              ),
              afterImage: Image.file(
                File(_changedImage!),
                width: 300,
                height: 300,
                fit: BoxFit.fill,
              ),
              isVertical: false,
            ),
          );
        } else {
          return Container(
            width: 300,
            height: 300,
            child: Center(
              child: Image.file(
                imgpath,
                width: 300,
                height: 300,
                fit: BoxFit.fill,
              ),
            ),
          );
        }
      }
    }
  }

  Future<File?> _cropImage(File? imgfile) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imgfile!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '图像裁剪工具',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: '图像裁剪工具',
        ));

    return croppedFile;
  }
}
