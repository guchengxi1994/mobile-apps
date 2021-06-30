import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:password_store_app/utils/common.dart';

const int itemCount = 10;

class SwiperTest extends StatefulWidget {
  SwiperTest({Key? key}) : super(key: key);

  @override
  _SwiperTestState createState() => _SwiperTestState();
}

class _SwiperTestState extends State<SwiperTest> {
  int currentIndex = 0;

  ScrollController scrollController = ScrollController();

  late List<Widget> items;

  @override
  void initState() {
    super.initState();
    items = buildItems();
    scrollController.addListener(() {
      // print(scrollController.offset);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 400,
            // width: 300,
            width: CommonUtil.screenW(),
            child: Swiper(
              key: UniqueKey(),
              pagination: buildPlugin(),
              onIndexChanged: (index) {
                // print(index);
                setState(() {
                  currentIndex = index;
                });
                scrollController.animateTo(currentIndex * 50,
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeOut);
              },
              itemCount: 10,
              viewportFraction: 0.8,
              scale: 0.9,
              index: currentIndex,
              itemBuilder: (context, index) {
                return items[index];
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 100),
            height: 50,
            width: CommonUtil.screenW(),
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: renderRow(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> renderRow() {
    List<Widget> w = [];
    for (int i = 0; i < itemCount; i++) {
      w.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        height: 50,
        width: 50,
        child: InkWell(
          onTap: () {
            print(i);
            setState(() {
              currentIndex = i;
            });
            print(currentIndex);
          },
          child: Center(
            child: Text(i.toString()),
          ),
        ),
      ));
    }
    return w;
  }

  buildItems() {
    List<Widget> w = [];
    for (int i = 0; i < itemCount; i++) {
      w.add(Container(
        color: Colors.grey,
        child: new Center(
          child: new Text("$i"),
        ),
      ));
    }
    return w;
  }

  buildPlugin() {
    // return SwiperPagination(
    //     alignment: Alignment.bottomCenter,
    //     builder: SwiperCustomPagination(
    //         builder: (BuildContext context, SwiperPluginConfig config) {
    //       return CustomP(config.activeIndex, itemCount);
    //     }));
    return SwiperPagination(
        builder: DotSwiperPaginationBuilder(
            activeColor: Colors.red, size: 10.0, activeSize: 10.0, space: 5.0));
  }
}

class CustomP extends StatelessWidget {
  var _currentIndex;
  var _length;
  CustomP(this._currentIndex, this._length);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      // height: 10,
      // height: ScreenAdapter.setHeight(10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: this._length,
            childAspectRatio: 5 / 1,
            crossAxisSpacing: 10),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
                color: _currentIndex == index ? Colors.red : Colors.white,
                borderRadius: BorderRadius.circular(10)),
          );
        },
        itemCount: _length,
      ),
    );
  }
}
