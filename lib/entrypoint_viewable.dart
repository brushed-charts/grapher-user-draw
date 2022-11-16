import 'package:flutter/widgets.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/gesture_controller.dart';

class GrapherUserDraw extends Viewable with EndlinePropagator {
  final GestureController _gestureController;
  GrapherUserDraw({GestureController? gestureController})
      : _gestureController = gestureController ?? GestureController() {
    eventRegistry.add(TapDownDetails, (p0) => _gestureController.onTapDown(p0));
    eventRegistry.add(DragUpdateDetails, (p0) => _gestureController.onDrag(p0));
  }
}
