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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: Container(
                width: CommonUtil.screenW() * 1,
                child: ListTile(
                  title: Text("Painting Demo"),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[200]),
                ),
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.grey[200]!),
                        bottom: BorderSide(color: Colors.grey[200]!))),
              ),
              onTap: () async {
                Navigator.of(context).pushNamed(Routers.drawing);
              },
            ),
          ],
        ),
      ),
    );
  }
}
