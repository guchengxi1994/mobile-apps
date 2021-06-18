import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ImagePickerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImagePickerState();
  }
}

class _ImagePickerState extends State<ImagePickerWidget> {
  PickedFile? _imgPath;
  PickedFile? _imgPath2;
  final ImagePicker _picker = ImagePicker();

  bool _loading = false;
  String _b64Code1 = '';
  String _b64Code2 = '';
  double sim = 0.0;
  Dio dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Similarity"),
      ),
      body: ModalProgressHUD(
          inAsyncCall: _loading,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _ImageView(_imgPath),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: _takePhoto,
                      child: Text("拍照"),
                    ),
                    Spacer(),
                    RaisedButton(
                      onPressed: _openGallery,
                      child: Text("选择照片"),
                    )
                  ],
                ),
                _ImageView2(_imgPath2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        _takePhoto(index: 1);
                      },
                      child: Text("拍照"),
                    ),
                    Spacer(),
                    RaisedButton(
                      onPressed: () {
                        _openGallery(index: 1);
                      },
                      child: Text("选择照片"),
                    )
                  ],
                ),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });

                      if (_imgPath != null && _imgPath2 != null) {
                        File f = new File(_imgPath!.path);
                        List<int> imageBytes = await f.readAsBytes();
                        _b64Code1 = base64Encode(imageBytes);

                        File f2 = new File(_imgPath2!.path);
                        List<int> imageBytes2 = await f2.readAsBytes();
                        _b64Code2 = base64Encode(imageBytes2);
                        String url = "http://192.168.50.99:3334/compare";
                        Req req = Req();
                        req.image1 = _b64Code1;
                        req.image2 = _b64Code2;
                        String jbrJson = json.encode(req.toJson());
                        Response response = await dio.post(url, data: jbrJson);
                        var result = response.data;
                        Resp resp = Resp.fromJson(json.decode(result));
                        setState(() {
                          sim = resp.similarity!;
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "无两张有效图",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }

                      setState(() {
                        _loading = false;
                      });
                    },
                    child: Text("对比")),
                Container(
                  height: 200,
                ),
                Text("相似度：" + sim.toString()),
              ],
            ),
          )),
    );
  }

  /*图片控件*/
  Widget _ImageView(imgPath) {
    if (imgPath == null) {
      return Center(
        child: Text("请选择图片或拍照"),
      );
    } else {
      return Image.file(
        File(imgPath!.path),
      );
    }
  }

  Widget _ImageView2(imgPath) {
    if (imgPath == null) {
      return Center(
        child: Text("请选择图片或拍照"),
      );
    } else {
      return Image.file(
        File(imgPath!.path),
      );
    }
  }

  /*拍照*/
  _takePhoto({int index = 0}) async {
    var image = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      if (index == 0) {
        _imgPath = image;
      } else {
        _imgPath2 = image;
      }
    });
  }

  /*相册*/
  _openGallery({int index = 0}) async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (index == 0) {
        _imgPath = image;
      } else {
        _imgPath2 = image;
      }
    });
  }
}

class Req {
  String? image1;
  String? image2;

  Req({this.image1, this.image2});

  Req.fromJson(Map<String, dynamic> json) {
    image1 = json['image1'];
    image2 = json['image2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image1'] = this.image1;
    data['image2'] = this.image2;
    return data;
  }
}

class Resp {
  int? code;
  double? similarity;

  Resp({this.code, this.similarity});

  Resp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    similarity = json['similarity'] * 1.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['similarity'] = this.similarity! * 1.0;
    return data;
  }
}
