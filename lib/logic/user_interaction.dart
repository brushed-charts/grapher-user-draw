library grapher_user_draw;

import 'package:grapher_user_draw/core/anchor_2d.dart';
import 'package:grapher_user_draw/logic/virtual_coord.dart';

class UserInteraction {
  Anchor2D? selection;
  void onTapDown(VirtualCoord coord) {}
  void onTapUp(VirtualCoord coord) {}
  void onDrag(VirtualCoord coord) {}
}
