/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-06-08 19:04:21
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-06-08 19:07:22
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_store_app/entity/userdata.dart';
import 'package:password_store_app/login/view/gesture_create.dart';
import 'package:password_store_app/login/view/gesture_verify.dart';
import 'package:password_store_app/main/view/mainpage.dart';
import 'package:password_store_app/main/widget/list_tile.dart';
import 'package:password_store_app/observer.dart';
import 'package:password_store_app/utils/common.dart';
import 'package:password_store_app/utils/database_util.dart';
import 'package:password_store_app/utils/sharedpreference_util.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   var isFirstTimeStart = await getIsFirstLogin();

//   runApp(MaterialApp(
//     // home: isFirstTimeStart ? GestureCreatePage() : GestureVerifyPage(),
//     home: MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Column(
//             children: [
//               UserDataWidget(UserData(
//                 appname: "职小侠",
//                 userId: '我',
//               )),
//               TextButton(
//                 onPressed: () {
//                   testSqlite();

//                   print(UserPasscodeUtil.encode("qwerty"));
//                 },
//                 child: Text("点击"),
//               )
//             ],
//           ),
//         ),
//       ),
//     ),
//   ));
// }

main(List<String> args) {
  Bloc.observer = Observer();
  // UserData.test_compare();
  runApp(new MaterialApp(
    home: MainPage(),
  ));
}



// import 'package:flutter/material.dart';

// import 'package:flip_card/flip_card.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'FlipCard',
//       theme: ThemeData.dark(),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   _renderBg() {
//     return Container(
//       decoration: BoxDecoration(color: const Color(0xFFFFFFFF)),
//     );
//   }

//   _renderAppBar(context) {
//     return MediaQuery.removePadding(
//       context: context,
//       removeBottom: true,
//       child: AppBar(
//         brightness: Brightness.dark,
//         elevation: 0.0,
//         backgroundColor: Color(0x00FFFFFF),
//       ),
//     );
//   }

//   _renderContent(context) {
//     return Card(
//       elevation: 0.0,
//       margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 20.0, bottom: 0.0),
//       color: Color(0x00000000),
//       child: FlipCard(
//         direction: FlipDirection.HORIZONTAL,
//         speed: 1000,
//         onFlipDone: (status) {
//           print(status);
//         },
//         front: Container(
//           decoration: BoxDecoration(
//             color: Color(0xFF006666),
//             borderRadius: BorderRadius.all(Radius.circular(8.0)),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text('Front', style: Theme.of(context).textTheme.headline1),
//               Text('Click here to flip back',
//                   style: Theme.of(context).textTheme.bodyText1),
//             ],
//           ),
//         ),
//         back: Container(
//           decoration: BoxDecoration(
//             color: Color(0xFF006666),
//             borderRadius: BorderRadius.all(Radius.circular(8.0)),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text('Back', style: Theme.of(context).textTheme.headline1),
//               Text('Click here to flip front',
//                   style: Theme.of(context).textTheme.bodyText1),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('FlipCard'),
//       ),
//       body: Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           _renderBg(),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               _renderAppBar(context),
//               Expanded(
//                 flex: 4,
//                 child: _renderContent(context),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Container(),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
