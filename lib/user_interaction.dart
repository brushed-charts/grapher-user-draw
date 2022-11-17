import 'package:grapher_user_draw/virtual_coord.dart';

import 'anchor.dart';

class UserInteraction {
  var shouldCreateAnchor = false;
  late VirtualCoord lastCoord;
  Anchor? lastAnchor;

  void onTap(VirtualCoord coord) {
    shouldCreateAnchor = true;
    lastCoord = coord;
    lastAnchor = Anchor();
  }

  void onDrag(VirtualCoord coord) {}
}
