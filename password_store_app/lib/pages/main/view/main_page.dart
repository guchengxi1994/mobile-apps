/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-06-18 16:17:05
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-06-18 16:19:21
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_store_app/entity/userdata.dart';
import 'package:password_store_app/pages/main/bloc/main_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_store_app/pages/main/widget/list_tile_component_bloc.dart';
import 'package:password_store_app/utils/routers.dart';

part 'package:password_store_app/pages/main/view/main_list_page.dart';
part 'package:password_store_app/pages/main/view/main_settings_page.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("P for Password",
            style: TextStyle(color: Colors.white, fontFamily: "Pangolin")),
      ),
      body: BlocProvider(
        create: (_) => MainBloc()..add(DataFetched()),
        child: UserDataList(),
      ),
    );
  }
}
