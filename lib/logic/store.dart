import 'package:grapher_user_draw/logic/figure.dart';
import 'package:grapher_user_draw/logic/virtual_coord.dart';

import '../core/anchor_2d.dart';

class FigureStore {
  var figures = <Figure>[];
  FigureStore();

  Anchor2D? x(Figure fig, coord) {
    print(fig.getHitObject(coord));
  }

  Anchor2D? getAnchorByCoord(VirtualCoord coord) {
    // final hitAnchors = figures.map((fig) => fig.getHitObject(coord));
    final hitAnchors = <Anchor2D>[];
    for (final figure in figures) {
      final anchor = figure.getHitObject(coord);
      if (anchor == null) continue;
      hitAnchors.add(anchor);
    }
    if (hitAnchors.isEmpty) return null;
    return hitAnchors.first;
  }

  add(Figure figure) {
    figures.add(figure);
  }
}
