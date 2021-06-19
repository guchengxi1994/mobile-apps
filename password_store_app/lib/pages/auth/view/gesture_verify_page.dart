import 'package:flutter/material.dart';
import 'package:password_store_app/auth/auth_utils.dart';
import 'package:password_store_app/utils/routers.dart';
import 'package:password_store_app/utils/sharedpreference_util.dart';
import 'package:gesture_unlock/lock_pattern.dart';

class GestureVerifyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("验证手势"),
        ),
        body: GestureVerify());
  }
}

// ignore: must_be_immutable
class GestureVerify extends StatefulWidget {
  @override
  GestureVerifyState createState() {
    return GestureVerifyState();
  }
}

class GestureVerifyState extends State<GestureVerify> {
  var _status = GestureCreateStatus.Verify;
  var _msg = "请绘制解锁手势";
  var _failedCount = 0;
  LockPattern? _lockPattern;
  String? _localPassword;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _localPassword = await getGesturePassword();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_lockPattern == null) {
      _lockPattern = LockPattern(
        padding: 30,
        onCompleted: _gestureComplete,
      );
    }
    return Center(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 12, bottom: 12),
              child: Center(
                child: Text(
                  _msg,
                  style: TextStyle(
                      color: _status == GestureCreateStatus.Verify_Failed
                          ? Colors.red
                          : Colors.black),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: _lockPattern,
              ),
            )
          ],
        ),
      ),
    );
  }

  _gestureComplete(List<int> selected, LockPatternStatus status) {
    setState(() {
      switch (_status) {
        case GestureCreateStatus.Verify:
        case GestureCreateStatus.Verify_Failed:
          var password = LockPattern.selectedToString(selected);
          print(password);
          if (_localPassword == password) {
            _msg = "解锁成功";
            _lockPattern?.updateStatus(LockPatternStatus.Success);
            Navigator.of(context).pushNamedAndRemoveUntil(
                Routers.main, (route) => route == null);
          } else {
            _failedCount++;
            if (_failedCount >= 5) {
              _status = GestureCreateStatus.Verify_Failed_Count_Overflow;
              _lockPattern?.updateStatus(LockPatternStatus.Disable);
              _msg = "多次验证失败，请5分钟后再次尝试";
            } else {
              _status = GestureCreateStatus.Verify_Failed;
              _lockPattern?.updateStatus(LockPatternStatus.Failed);
              _msg = "验证失败，请重新尝试";
            }
          }
          break;
        case GestureCreateStatus.Verify_Failed_Count_Overflow:
          break;
        default:
          break;
      }
    });
  }
}
