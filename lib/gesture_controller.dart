import 'package:flutter/widgets.dart';

class GestureController {
  Offset? pointerCoord;

  @override
  void onTapDown(TapDownDetails event) {
    pointerCoord = event.localPosition;
  }

  @override
  void onDrag(DragUpdateDetails event) {
    pointerCoord = event.localPosition;
  }
}
