import 'package:drawing/painters/painters.dart';
import 'package:drawing/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/tree_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => TreeBloc()..add(const TreeInitialEvent(level: 1)),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TreeLeaf treeLeaf;
  late TreeBloc _treeBloc;

  @override
  void initState() {
    super.initState();
    treeLeaf = TreeLeaf(offset: const Offset(100, 100), shadow: true, id: 0);
    _treeBloc = context.read<TreeBloc>();
    // print(_treeBloc.state.objects);
  }

  Future<void> paintTree() async {
    for (var _ in _treeBloc.state.paintObjects) {
      _treeBloc.add(TreePaintEvent());
      print(_treeBloc.state.paintObjects
          .getRange(0, _treeBloc.state.currentIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TreeBloc, TreeState>(builder: (context, state) {
      paintTree();
      return CustomPaint(
        foregroundPainter: TreePainter(
            objects: _treeBloc.state.paintObjects
                .getRange(0, _treeBloc.state.currentIndex)
                .toList()),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        ),
      );
    });
  }
}
