library grapher_user_draw;

import 'package:grapher_user_draw/core/virtual_coord_interface.dart';

import 'anchor.dart';

class Anchor2D extends Anchor {
  static const hitPerimeter = 10;
  double y;
  Anchor2D(int groupID, DateTime x, this.y) : super(groupID, x);

  @override
  String toString() {
    return 'Anchor2D(group: $groupID, x: $x, y: $y)';
  }

  @override
  bool isHit(covariant VirtualCoordInterface coord) {
    if (!super.isHit(coord)) return false;
    if (y - hitPerimeter > coord.y) return false;
    if (y + hitPerimeter < coord.y) return false;
    return true;
  }
}
