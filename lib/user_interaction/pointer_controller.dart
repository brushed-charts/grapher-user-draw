import 'package:flutter/widgets.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/user_interaction/gesture_interpreter.dart';

class PointerController extends Viewable with EndlinePropagator {
  late final GestureInterpreter _gestureInterpreter;

  PointerController(this._gestureInterpreter) {
    eventRegistry.add(TapUpDetails, (p0) => _gestureInterpreter.onTapUp(p0));
    eventRegistry.add(
        DragUpdateDetails, (p0) => _gestureInterpreter.onDrag(p0));
    eventRegistry.add(
        DragEndDetails, (p0) => _gestureInterpreter.onDragEnd(p0));
  }
}
