part of './main_page.dart';

class ConvertionPage extends StatefulWidget {
  @override
  ConvertionState createState() => ConvertionState();
}

class ConvertionState extends State {
  var _imgPath;
  String? filename;
  bool _isConverting = false;
  String? _changedImage;
  final platform = MethodChannel("face.convert");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '美美哒',
          style: TextStyle(fontFamily: "MaShanZheng"),
        ),
      ),
      body: SingleChildScrollView(
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
                          var image = await ImagePicker.pickImage(
                              source: ImageSource.gallery);

                          setState(() {
                            _imgPath = image;
                            print(image.path);
                            filename = image.path;
                          });
                          print("==========================");
                          print(filename);
                          print("==========================");
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
                        setState(() {
                          _isConverting = true;
                        });

                        getResult().then((value) {
                          print(value.runtimeType);
                          if (value.runtimeType == String) {
                            _changedImage = value;
                          }
                          setState(() {
                            _isConverting = false;
                          });
                        });
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
                          var result = await ImageGallerySaver.saveImage(bytes);
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
    );
  }

  Future<String?> getResult() async {
    if (filename != null) {
      dynamic resultValue = await platform.invokeMethod("convert", filename);
      // print(resultValue.runtimeType);
      setState(() {
        _imgPath = File(resultValue);
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
          child: Text("请选择一张图片\n最好是正面肖像"),
        ),
      );
    } else {
      return Container(
        height: 300,
        width: 300,
        child: Image.file(
          imgpath,
          width: 300,
          height: 300,
        ),
      );
    }
  }
}
