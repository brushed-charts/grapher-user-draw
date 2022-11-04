library grapher_user_draw;

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
}
