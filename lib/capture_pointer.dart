import 'package:flutter/cupertino.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/pointer/helper/drag.dart';
import 'package:grapher/pointer/helper/hit.dart';
import 'package:grapher/view/viewable.dart';

class CapturePointer extends Viewable
    with EndlinePropagator, HitHelper, DragHelper {
  Offset? tapPos;
  DragUpdateDetails? drag;

  @override
  void onTapDown(TapDownDetails event) {
    tapPos = event.localPosition;
  }

  @override
  void onDrag(DragUpdateDetails event) {
    drag = event;
  }
}
