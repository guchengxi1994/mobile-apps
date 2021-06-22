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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mainBloc = context.read<MainBloc>();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(builder: (context, state) {
      // print(state.userDatas.length);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: buildSearchBar(),
        ),
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
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(
            Icons.add,
            size: 30,
            color: Colors.black,
          ),
          label: Text(
            "Add",
            style: TextStyle(
              fontFamily: "Pangolin",
              fontSize: 20,
              color: Colors.black,
            ),
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

  Widget buildSearchBar() {
    return Container(color: Colors.white, child: searchBar());
  }

  Widget searchBar() {
    return Container(
      height: 50,

      /// 设置外边距
      // margin: EdgeInsets.all(1),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            /// 里面的数值尽可能大才是左右半圆形，否则就是普通的圆角形
            Radius.circular(50),
          ),
        ),
        child: TextField(
          onSubmitted: (value) {
            var searchStr = _searchController.text;
            _mainBloc.add(DataFilter(searchStr: searchStr));
          },

          onChanged: (value) {
            if (_searchController.text == "") {
              _mainBloc.add(DataFetched());
            }
          },

          /// 设置字体
          style: TextStyle(
            fontSize: 20,
          ),
          textInputAction: TextInputAction.search,
          textAlign: TextAlign.left,
          controller: _searchController,

          /// 设置输入框样式
          decoration: InputDecoration(
            // fillColor: Colors.white,
            hintText: '请输入App名(支持模糊查询)',

            /// 边框
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                /// 里面的数值尽可能大才是左右半圆形，否则就是普通的圆角形
                Radius.circular(50),
              ),
            ),

            ///设置内容内边距
            contentPadding: EdgeInsets.only(
              top: 0,
              bottom: 0,
            ),

            /// 前缀图标
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
