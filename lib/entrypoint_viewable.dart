import 'package:flutter/widgets.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/gesture_controller.dart';
import 'package:grapher_user_draw/refresh_service.dart';

class GrapherUserDraw extends Viewable with EndlinePropagator {
  final GestureController _gestureController;
  GrapherUserDraw({GestureController? gestureController})
      : _gestureController = gestureController ?? GestureController() {
    RefreshService(this);
    eventRegistry.add(TapDownDetails, (p0) => _gestureController.onTapDown(p0));
    eventRegistry.add(DragUpdateDetails, (p0) => _gestureController.onDrag(p0));
    eventRegistry.add(TapUpDetails, (p0) => _gestureController.onTapUp(p0));
  }

  @override
  void draw(covariant ViewEvent viewEvent) {
    super.draw(viewEvent);
    final coordTranslator = CoordTranslater(viewEvent.xAxis, viewEvent.yAxis);
    _gestureController.updateTranslator(coordTranslator);
  }
}
