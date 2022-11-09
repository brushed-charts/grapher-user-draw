library grapher_user_draw;

import 'package:grapher_user_draw/core/anchor_2d.dart';
import 'package:grapher_user_draw/logic/anchor_operation.dart';
import 'package:grapher_user_draw/logic/user_interaction_interface.dart';
import 'package:grapher_user_draw/logic/virtual_coord.dart';

class EditionInteraction implements UserInteractionInterface {
  Anchor2D? selection;
  final AnchorOperation operation;

  EditionInteraction(this.operation);

  @override
  void handleTap(VirtualCoord coord) {
    selection = operation.anchorSelected(coord);
  }

  @override
  void handleDragStart(VirtualCoord coord) {
    selection = operation.anchorSelected(coord);
  }

  @override
  void handleDrag(VirtualCoord newCoord) {
    if (selection == null) return;
    operation.moveAnchor(selection, newCoord);
  }

  @override
  void handleDragEnd(VirtualCoord coord) {
    selection = null;
  }
}
