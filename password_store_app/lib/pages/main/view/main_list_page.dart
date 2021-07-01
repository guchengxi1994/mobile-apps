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
  int type;
  UserDataList({required this.type});
  @override
  _UserDataListState createState() => _UserDataListState();
}

class _UserDataListState extends State<UserDataList> {
  final _scrollController = ScrollController();
  late MainBloc _mainBloc;
  final TextEditingController _searchController = TextEditingController();
  int currentIndex = 0;
  ScrollController scrollController = ScrollController();

  late int itemCount;

  @override
  void initState() {
    super.initState();
    _mainBloc = context.read<MainBloc>();
    itemCount = _mainBloc.state.userDatas.length;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    scrollController.dispose();
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
        body: widget.type == 0
            ? ListView.builder(
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
                })
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 500,
                      width: CommonUtil.screenW(),
                      child: Swiper(
                        key: UniqueKey(),
                        itemCount: state.userDatas.length,
                        viewportFraction: 0.7,
                        scale: 0.9,
                        index: currentIndex,
                        itemBuilder: (context, index) {
                          return UserDataWidget(index);
                        },
                        onIndexChanged: (index) {
                          // setState(() {
                          //   currentIndex = index;
                          // });
                          currentIndex = index;
                          scrollController.animateTo(currentIndex * 50,
                              duration: Duration(milliseconds: 100),
                              curve: Curves.easeOut);
                        },
                      ),
                    ),
                    Container(
                      // margin: EdgeInsets.only(top: 100),
                      alignment: Alignment.center,
                      height: 50,
                      width: CommonUtil.screenW(),
                      child: ListView.builder(
                          controller: scrollController,
                          key: UniqueKey(),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.userDatas.length,
                          itemBuilder: (BuildContext context, int index) {
                            late String _mark;
                            if (null ==
                                    _mainBloc.state.userDatas[index].appname ||
                                "" ==
                                    _mainBloc.state.userDatas[index].appname) {
                              _mark = "?";
                            } else {
                              _mark =
                                  _mainBloc.state.userDatas[index].appname![0];
                            }
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.all(
                                    /// 里面的数值尽可能大才是左右半圆形，否则就是普通的圆角形
                                    Radius.circular(50),
                                  ),
                                ),
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: new Center(
                                  child: new Text(_mark),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
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
            var result = await showCupertinoDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text(
                      "添加方式",
                      style: TextStyle(color: Colors.blue),
                    ),
                    children: [
                      SimpleDialogOption(
                        child: Text("直接添加"),
                        onPressed: () async {
                          UserData result = await Navigator.of(context)
                              .pushNamed(Routers.createUserData) as UserData;

                          if (result != null) {
                            _mainBloc.add(DataAdded(userData: result));
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                      SimpleDialogOption(
                        child: Text("二维码添加"),
                        onPressed: () async {
                          var results = await Navigator.of(context)
                              .pushNamed(Routers.qrscan);

                          if (results != null && results != []) {
                            _mainBloc.add(
                                DataAddList(datas: results as List<UserData>));
                          }

                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
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
