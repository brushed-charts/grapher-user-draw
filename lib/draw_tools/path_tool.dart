import 'dart:ui';

import 'package:grapher_user_draw/anchor.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/draw_tools/draw_info.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

import '../figure.dart';
import 'draw_tool_interface.dart';

abstract class PathTool implements DrawToolInterface {
  static const double anchorSize = 5;
  abstract final Paint paint;
  late Canvas canvas;
  late CoordTranslater coordTranslater;

  @override
  draw(DrawInfo info, Figure figure) {
    _extractInfo(info);
    _drawPath(figure);
  }

  _drawPath(Figure figure) {
    Anchor? previousAnchor;
    for (final anchor in figure.getAll()) {
      _drawAnchor(anchor);
      if (previousAnchor != null) _drawLink(previousAnchor, anchor);
      previousAnchor = anchor;
    }
  }

  _extractInfo(DrawInfo info) {
    canvas = info.canvas;
    coordTranslater = info.coordTranslater;
  }

  _drawAnchor(Anchor anchor) {
    final center = coordTranslater.toPixel(VirtualCoord(anchor.x, anchor.y));
    if (center == null) return;
    canvas.drawCircle(center, anchorSize, paint);
  }

  _drawLink(Anchor prev, Anchor curr) {
    final centerA = coordTranslater.toPixel(VirtualCoord(prev.x, prev.y));
    final centerB = coordTranslater.toPixel(VirtualCoord(curr.x, curr.y));
    if (centerA == null || centerB == null) return;
    canvas.drawLine(centerA, centerB, paint);
  }
}
