library grapher_user_draw;

import 'anchor.dart';

class Anchor2D extends Anchor {
  double y;
  Anchor2D(int groupID, DateTime x, this.y) : super(groupID, x);

  @override
  String toString() {
    return 'Anchor2D(group: $groupID, x: $x, y: $y)';
  }
}
