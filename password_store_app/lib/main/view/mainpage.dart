import 'package:flutter/material.dart';
import 'package:password_store_app/main/bloc/main_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_store_app/main/widget/list_tile_component_bloc.dart';

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
      print(state.userDatas.length);
      return ListView.builder(
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
          });
    });
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => MainBloc()..add(DataFetched()),
        child: UserDataList(),
      ),
    );
  }
}
