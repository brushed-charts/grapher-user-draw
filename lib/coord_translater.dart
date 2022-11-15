import 'dart:ui';

import 'package:grapher/view/axis/unit-axis.dart';
import 'package:grapher/view/axis/virtual-axis.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

class CoordTranslater {
  UnitAxis xAxis;
  VirtualAxis yAxis;

  CoordTranslater(this.xAxis, this.yAxis);

  VirtualCoord? toVirtual(Offset offset) {
    final x = xAxis.toVirtual(offset.dx);
    final y = yAxis.toVirtual(offset.dy);
    if (x == null) return null;
    return VirtualCoord(x, y);
  }

  Offset? toPixel(VirtualCoord virtualCoord) {
    final x = xAxis.toPixel(virtualCoord.x);
    final y = yAxis.toPixel(virtualCoord.y);
    if (x == null) return null;
    return Offset(x, y);
  }
}
