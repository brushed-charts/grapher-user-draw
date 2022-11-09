import 'package:grapher_user_draw/logic/virtual_coord.dart';

import '../core/anchor_2d.dart';

class AnchorOperation {
  Anchor2D? anchorSelected(VirtualCoord coord) {}
  createAnchor(VirtualCoord coord) {}

  void moveAnchor(Anchor2D? selection, VirtualCoord newCoord) {
    if (selection == null) return;
    selection.x = newCoord.x;
    selection.y = newCoord.y;
  }
}
