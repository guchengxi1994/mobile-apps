part of './main_page.dart';

class ConvertionPage extends StatefulWidget {
  @override
  ConvertionState createState() => ConvertionState();
}

class ConvertionState extends State {
  var _imgPath;
  String? filename;
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
            children: [
              _ImageView(_imgPath),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      print("babalaka");
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                      setState(() {
                        _imgPath = image;
                        print(image.path);
                        filename = image.path;
                      });
                    },
                    child: Text("select"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      print("kakabala");
                      dynamic resultValue =
                          await platform.invokeMethod("convert", filename);

                      // print(resultValue);
                      setState(() {
                        _imgPath = File(resultValue);
                      });
                    },
                    child: Text("convert"),
                  )
                ],
              ))
            ],
          ),
        ));
  }

  Widget _ImageView(imgpath) {
    if (imgpath == null) {
      // return Center(
      //   child: Text("plz choose an image"),
      // );
      return Container(
        height: 300,
        width: 300,
        child: Center(
          child: Text("plz choose an image"),
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
