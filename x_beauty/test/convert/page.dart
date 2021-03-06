import 'dart:convert';
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:x_beauty/pages/convert/bloc/convert_bloc.dart';
import 'package:x_beauty/utils/common.dart';

class ConvertBlocPage extends StatelessWidget {
  const ConvertBlocPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConvertBloc()..add(ConvertInitEvent()),
      child: ConvertionPage(),
    );
  }
}

class ConvertionPage extends StatefulWidget {
  @override
  ConvertionState createState() => ConvertionState();
}

class ConvertionState extends State {
  // var _imgPath;
  String? filename;
  bool _isConverted = false;
  final ImagePicker _picker = ImagePicker();
  String? _changedImage;
  final platform = MethodChannel("face.convert");

  late ConvertBloc _convertBloc;

  @override
  void initState() {
    super.initState();
    _convertBloc = context.read<ConvertBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConvertBloc, ConvertState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              CommonUtil.appName,
              style: TextStyle(fontFamily: "MaShanZheng"),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50, bottom: 50),
                  child: _ImageView(File(_convertBloc.state.originImgPath)),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: new BoxDecoration(
                          //?????????????????? ?????? ???????????????????????? ???Container height ?????????
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          //??????????????????
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
                              });

                              if (null != image) {
                                _convertBloc.add(ConvertChoseImgEvent(
                                    chosenImgPath: image.path));
                                filename = image.path;
                                // setState(() {
                                //   print(image.path);
                                //   _imgPath = File(image.path);

                                //   filename = image.path;
                                // });
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "????????????????????????????????????",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: Text("??????"),
                        ),
                      ),
                      Container(
                        decoration: new BoxDecoration(
                          //?????????????????? ?????? ???????????????????????? ???Container height ?????????
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          //??????????????????
                          border: new Border.all(width: 1, color: Colors.red),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            print("kakabala");
                            // setState(() {
                            //   _isConverted = false;
                            // });

                            // getResult().then((value) {
                            //   print(value.runtimeType);
                            //   if (value.runtimeType == String) {
                            //     _changedImage = value;
                            //   }
                            // });

                            _convertBloc.add(ConvertChangingEvent(
                                filePath: filename!, type: 0));

                            _changedImage = _convertBloc.state.convertedImgPath;
                          },
                          child: Text("??????"),
                        ),
                      ),
                      Container(
                        decoration: new BoxDecoration(
                          //?????????????????? ?????? ???????????????????????? ???Container height ?????????
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          //??????????????????
                          border: new Border.all(width: 1, color: Colors.red),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            // print(_changedImage);
                            if (_changedImage != null) {
                              File imageData = File(_changedImage!);
                              List<int> imageBytes =
                                  imageData.readAsBytesSync();
                              String bs64 = base64Encode(imageBytes);
                              var bytes = Base64Decoder().convert(bs64);
                              var result =
                                  await ImageGallerySaver.saveImage(bytes);
                              print(result);
                              print(result.runtimeType);
                              if (result == null ||
                                  result['filePath'] == null) {
                                Fluttertoast.showToast(
                                    msg: "????????????",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "??????????????????",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "??????????????????",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: Text("??????"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> getResult() async {
    Map<String, Object> map = {"filename": filename!, "type": 0};
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
          msg: "????????????????????????",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      return null;
    }
  }

  Widget _ImageView(File imgpath) {
    if (imgpath == null || imgpath.path == "") {
      // return Center(
      //   child: Text("plz choose an image"),
      // );
      return Container(
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.blue)),
        height: 300,
        width: 300,
        child: Center(
          child: Text("?????????????????????\n?????????????????????"),
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
                    // setState(() {
                    //   _imgPath = result;
                    //   filename = result.path;
                    // });
                    _convertBloc
                        .add(ConvertChoseImgEvent(chosenImgPath: result.path));
                    filename = result.path;
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
                    child: Text("???????????????????????????"),
                  )
                : Container(),
          ],
        );
      } else {
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
            toolbarTitle: '??????????????????',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: '??????????????????',
        ));

    return croppedFile;
  }
}
