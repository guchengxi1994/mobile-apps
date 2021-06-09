import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String?> showCustomDialog(BuildContext context, {String? title}) async {
  String result = await showCupertinoDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller = TextEditingController();
        return CupertinoAlertDialog(
          title: Text("请修改" + (title ?? "")),
          content: Card(
            elevation: 0.0,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      // hintText: 'input wahatever you want',
                      filled: true,
                      fillColor: Colors.grey.shade50),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: Text('取消'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context, controller.text.toString());
              },
              child: Text('确定'),
            ),
          ],
        );
      });

  // print(result);
  return result;
}
