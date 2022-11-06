library grapher_user_draw;

import 'package:grapher_user_draw/core/virtual_coord_interface.dart';

import 'group_contract.dart';

abstract class Anchor implements GroupDataStruct {
  @override
  final int groupID;
  DateTime x;
  Anchor(this.groupID, this.x);

  @override
  String toString() {
    return 'Anchor(group: $groupID, x: $x})';
  }

  bool isHit(VirtualCoordInterface coord) {
    if (coord.x == x) return true;
    return false;
  }
}
