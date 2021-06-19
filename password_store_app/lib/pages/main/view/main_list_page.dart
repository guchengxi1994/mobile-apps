/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-06-16 19:03:37
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-06-18 16:18:24
 */

part of 'package:password_store_app/pages/main/view/main_page.dart';

class UserDataList extends StatefulWidget {
  @override
  _UserDataListState createState() => _UserDataListState();
}

class _UserDataListState extends State<UserDataList> {
  final _scrollController = ScrollController();
  late MainBloc _mainBloc;

  @override
  void initState() {
    super.initState();
    _mainBloc = context.read<MainBloc>();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(builder: (context, state) {
      // print(state.userDatas.length);
      return Scaffold(
        body: ListView.builder(
            controller: _scrollController,
            itemCount: state.userDatas.length,
            itemBuilder: (BuildContext context, int index) {
              if (index < state.userDatas.length) {
                return UserDataWidget(index);
              } else {
                return Container(
                  child: Text("无更多"),
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 40,
            color: Colors.black,
          ),
          onPressed: () async {
            // print('FloatingActionButton');
            UserData result = await Navigator.of(context)
                .pushNamed(Routers.createUserData) as UserData;

            /// fake result
            if (result != null) {
              // result.appname = "cccc";
              // result.userId = "asdasd";
              _mainBloc.add(DataAdded(userData: result));
            }
          },
          backgroundColor: Colors.yellow,
        ),
      );
    });
  }
}
