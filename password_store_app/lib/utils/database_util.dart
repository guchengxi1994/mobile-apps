import 'dart:io';

import 'package:password_store_app/entity/userdata.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<bool> pathExists() async {
  var databasePath = await getDatabasesPath();
  String path = join(databasePath, "userdata.db");
  File f = File(path);
  bool exist = await f.exists();
  return exist;
}

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
  UserData dd = (await userProvider.getTodo(1))!;
  print("todo:${dd.toJson()}");
  await userProvider.close();
}

Future<List<UserData>?> fetchUserData() async {
  UserDataProvider userProvider = UserDataProvider();
  var databasePath = await getDatabasesPath();
  String path = join(databasePath, "userdata.db");
  await userProvider.open(path);
  List<UserData>? res = await userProvider.getAll();
  await userProvider.close();
  return res;
}

Future deleteData(int id) async {
  UserDataProvider userProvider = UserDataProvider();
  var databasePath = await getDatabasesPath();
  String path = join(databasePath, "userdata.db");
  await userProvider.open(path);
  await userProvider.delete(id);
  await userProvider.close();
}

Future updateData(UserData userData) async {
  UserDataProvider userProvider = UserDataProvider();
  var databasePath = await getDatabasesPath();
  String path = join(databasePath, "userdata.db");
  await userProvider.open(path);
  await userProvider.update(userData);
  await userProvider.close();
}

Future insertToDB(UserData userData) async {
  UserDataProvider userProvider = UserDataProvider();
  var databasePath = await getDatabasesPath();
  String path = join(databasePath, "userdata.db");
  await userProvider.open(path);
  await userProvider.insert(userData);
  await userProvider.close();
}
