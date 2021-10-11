import 'package:drawing/models/models.dart';

main(List<String> args) {
  TreeModel treeModel = TreeModel(levels: 1, stickNumber: 2);

  List l = treeModel.generateTreeModel();

  print(l);

  // print(l.where((element) {
  //   if (element.runtimeType == StickModel && element.layerId == 2) {
  //     return true;
  //   }
  //   return false;
  // }));
}
