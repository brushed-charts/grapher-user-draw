import 'package:flutter/widgets.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/gesture_controller.dart';

class PointerController extends Viewable with EndlinePropagator {
  late final GestureController _gestureController;

  PointerController(this._gestureController) {
    eventRegistry.add(TapDownDetails, (p0) => _gestureController.onTapDown(p0));
    eventRegistry.add(DragUpdateDetails, (p0) => _gestureController.onDrag(p0));
    eventRegistry.add(TapUpDetails, (p0) => _gestureController.onTapUp(p0));
  }
}
