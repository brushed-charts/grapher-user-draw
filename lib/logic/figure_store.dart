import 'package:grapher_user_draw/logic/figure.dart';
import 'package:grapher_user_draw/logic/virtual_coord.dart';

import '../core/anchor.dart';

class FigureStore {
  var figures = <Figure>[];

  Anchor? getAnchorByCoord(VirtualCoord coord) {
    for (final figure in figures) {
      final anchor = figure.getHitObject(coord);
      if (anchor != null) return anchor;
    }
    return null;
  }

  void add(Figure figure) {
    figures.add(figure);
  }
}
