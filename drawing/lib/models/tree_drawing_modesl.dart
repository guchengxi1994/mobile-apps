///          0                 root
///         1, 2               first-level stack
///        3,4  5,6            second-level stack
///     7,8 9,10 11,12 13,14   third-level stack
///        0
///      1,2,3
///    4,5,6 7,8,9 10,11,12
///
///   13,14,15 16, 17, 18 19, 20, 21 22, 23, 24 25, 26, 27 28, 29, 30 ...

class TreeModel {
  /// must >= 1 ;3 recommended
  int levels;
  int stickNumber;

  TreeModel({required this.levels, required this.stickNumber});

  List generateTreeModel() {
    List l = [];
    // root
    l.add(0);

    int currentId = 0;
    // int layerObjId = 0;

    // int stickNumber = 2;
    List<int> stickList = [];
    for (int j = 1; j <= stickNumber; j++) {
      currentId += 1;
      stickList.add(currentId);
    }
    l.add(RootModel(childIds: stickList));

    for (int i = 1; i < levels; i++) {
      List itemList = l.where((element) {
        if ((element.runtimeType == StickModel ||
                element.runtimeType == RootModel) &&
            element.layerId == i - 1) {
          return true;
        }
        return false;
      }).toList();
      List items = [];
      for (var _i in itemList) {
        items.addAll(_i.childIds);
      }

      for (int j = 1; j <= items.length; j++) {
        List<int> stickList = [];
        for (var k = 0; k < stickNumber; k++) {
          currentId += 1;
          stickList.add(currentId);
        }
        l.add(StickModel(childIds: stickList, id: j - 1, layerId: i));
      }
    }

    return l;
  }
}

class StickModel {
  List<int> childIds;

  int id;

  int layerId;

  StickModel({required this.childIds, required this.id, required this.layerId});

  @override
  String toString() {
    return childIds.toString() +
        '::' +
        id.toString() +
        '::' +
        layerId.toString();
  }
}

class RootModel {
  List<int> childIds;

  int layerId = 0;

  RootModel({required this.childIds});

  @override
  String toString() {
    return childIds.toString() + '::root';
  }
}

class LeafModel {
  int id;

  LeafModel({required this.id});
}
