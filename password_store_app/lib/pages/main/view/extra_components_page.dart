part of 'package:password_store_app/pages/main/view/main_page.dart';

class ExtraComponents extends StatelessWidget {
  const ExtraComponents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Extra Tools",
            style: TextStyle(color: Colors.white, fontFamily: "Pangolin")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [Text("这是客制工具")],
        ),
      ),
    );
  }
}
