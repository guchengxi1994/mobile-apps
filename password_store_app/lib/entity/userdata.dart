import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:password_store_app/utils/common.dart';
import 'package:sqflite/sqflite.dart';

/// 表名
final String tableName = 'UserData';

/// _id字段
final String columnId = 'rid';

/// 用户名字段
final String columnUserId = 'userId';

/// 口令字段
final String columnUserPasscode = 'userPasscode';

/// 口令类型字段
final String columnPasscodeType = 'passcodeType';

/// app名字段
final String columnAppname = 'appname';

/// 是否随机
final String columnIsRandom = 'isRandom';

/// 是否混淆
final String columnIsFuzzy = 'isFuzzy';

/// 混淆字符串 盐
final String columnSalt = "salt";

/// scheme 跳转
final String columnScheme = "scheme";

/// 操作todo表的工具类
class UserDataProvider {
  /// 单例
  factory UserDataProvider() => _getInstance();
  static UserDataProvider get instance => _getInstance();
  static UserDataProvider? _instance;

  UserDataProvider._internal();

  static UserDataProvider _getInstance() {
    if (_instance == null) {
      _instance = UserDataProvider._internal();
    }
    return _instance!;
  }

  late Database db;

  /// 打开数据库，并创建todo表
  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table IF NOT EXISTS $tableName  ( 
  $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
  $columnUserId text not null,
  $columnUserPasscode text ,
  $columnPasscodeType text ,
  $columnAppname text not null,
  $columnIsRandom integer ,
  $columnIsFuzzy integer ,
  $columnSalt text,
  $columnScheme text);
''');
    });
  }

  Future<UserData> insert(UserData todo) async {
    todo.rid = await db.insert(tableName, todo.toJson());
    return todo;
  }

  Future<UserData?> getTodo(int id) async {
    List<Map> maps = await db.query(tableName,
        columns: [
          columnId,
          columnUserId,
          columnUserPasscode,
          columnPasscodeType,
          columnAppname,
          columnIsRandom,
          columnIsFuzzy,
          columnSalt,
          columnScheme
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return UserData.fromJson(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(UserData todo) async {
    return await db.update(tableName, todo.toJson(),
        where: '$columnId = ?', whereArgs: [todo.rid]);
  }

  Future close() async => db.close();

  Future<List<UserData>?> getAll() async {
    List<Map> maps = await db.query(
      tableName,
    );
    if (maps.length > 0) {
      return maps.map((e) {
        return UserData.fromJson(e);
      }).toList();
    }
    return null;
  }
}

class UserData {
  int? rid; // row id
  String? userId;
  String? userPasscode;
  String? passcodeType;
  String? appname;
  bool? isRandom;
  bool? isFuzzy;
  String? salt;
  String? scheme;

  UserData(
      {this.rid,
      @required this.userId,
      this.userPasscode,
      this.passcodeType,
      @required this.appname,
      this.isRandom,
      this.isFuzzy,
      this.salt,
      this.scheme});

  UserData.fromJson(Map<dynamic, dynamic> json) {
    rid = json['rid'];
    userId = json['userId'];
    userPasscode = json['userPasscode'];
    passcodeType = json['passcodeType'];
    appname = json['appname'] ?? "";
    isRandom = json['isRandom'].runtimeType == bool
        ? json['isRandom']
        : int2bool(json['isRandom']);
    isFuzzy = json['isFuzzy'].runtimeType == bool
        ? json['isFuzzy']
        : int2bool(json['isFuzzy']);
    salt = json['salt'] ?? "";
    scheme = json['scheme'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rid'] = this.rid;
    data['userId'] = this.userId ?? "未设定";
    data['userPasscode'] = this.userPasscode ?? "未设定";
    data['passcodeType'] = this.passcodeType ?? "未设定";
    data['appname'] = this.appname ?? "未设定";
    if (null != this.isRandom) {
      data['isRandom'] = this.isRandom.runtimeType == int
          ? this.isRandom
          : bool2int(this.isRandom!);
    } else {
      data['isRandom'] = 0;
    }
    if (this.isFuzzy != null) {
      data['isFuzzy'] = this.isFuzzy.runtimeType == int
          ? this.isFuzzy
          : bool2int(this.isFuzzy!);
    } else {
      data['isFuzzy'] = 1;
    }
    data['salt'] = this.salt ?? "";
    data["scheme"] = this.scheme ?? "";

    return data;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    if (this.runtimeType != other.runtimeType) {
      return false;
    }
    // ignore: test_types_in_equals
    other = other as UserData;
    return identical(this, other) ||
        (this.appname == other.appname &&
            this.isFuzzy == other.isFuzzy &&
            this.isRandom == other.isRandom &&
            this.passcodeType == other.passcodeType &&
            this.rid == other.rid &&
            this.salt == other.salt &&
            this.scheme == other.scheme &&
            this.userId == other.userId &&
            this.userPasscode == other.userPasscode);
  }

  void clear() {
    this.appname = "";
    this.isFuzzy = true;
    this.isRandom = false;
    this.passcodeType = "";
    this.salt = "";
    this.scheme = "";
    this.userId = "";
    this.userPasscode = "";
  }

  static void test_compare() {
    UserData userData1 = UserData(userId: "1111", appname: "111111");
    UserData userData2 = UserData(userId: "2222", appname: "222222");
    print(userData2 == userData1);
    UserData userData3 =
        UserData(userId: "1111", appname: "111111", userPasscode: "usercode");
    print(userData3 == userData1);
  }
}
