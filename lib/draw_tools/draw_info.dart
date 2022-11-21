import 'dart:ui';

import 'package:grapher/view/view-event.dart';
import 'package:grapher_user_draw/coord_translater.dart';

class DrawInfo {
  final ViewEvent event;
  final Canvas canvas;
  final CoordTranslater coordTranslater;
  DrawInfo(this.event)
      : canvas = event.canvas,
        coordTranslater = CoordTranslater(event.xAxis, event.yAxis);
}
