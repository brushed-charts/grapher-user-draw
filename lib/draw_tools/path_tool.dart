import 'dart:ui';

import 'package:grapher_user_draw/anchor.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/draw_tools/draw_info.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

import '../figure.dart';
import 'draw_tool_interface.dart';

abstract class PathTool implements DrawToolInterface {
  static const double anchorSize = 10;
  late final Canvas canvas;
  late final CoordTranslater coordTranslater;

  @override
  draw(DrawInfo info, Figure figure) {
    _init(info);
    for (final anchor in figure.getAll()) {
      _drawAnchor(anchor);
    }
  }

  _init(DrawInfo info) {
    canvas = info.canvas;
    coordTranslater = info.coordTranslater;
  }

  _drawAnchor(Anchor anchor) {
    final center = coordTranslater.toPixel(VirtualCoord(anchor.x, anchor.y));
    if (center == null) return;
    canvas.drawCircle(center, anchorSize, Paint());
  }
}
