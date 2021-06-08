import 'package:password_store_app/entity/userdata.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

testSqlite() async {
  UserDataProvider userProvider = UserDataProvider();

  var databasePath = await getDatabasesPath();
  String path = join(databasePath, "userdata.db");

  /// 删除数据库
  await deleteDatabase(path);

  /// 打开数据库
  await userProvider.open(path);

  ///
  UserData userData = UserData();
  userData.appname = "appname1";
  userData.userId = "userId1";
  UserData d = await userProvider.insert(userData);
  print('inserted:${d.toJson()}');

  /// 查询数据
  UserData dd = await userProvider.getTodo(1);
  print("todo:${dd.toJson()}");
}
