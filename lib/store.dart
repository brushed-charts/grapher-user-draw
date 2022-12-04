import 'package:grapher_user_draw/anchor.dart';

import 'figure.dart';

class FigureStore {
  final _figures = <int, Figure>{};
  int get length => _figures.length;

  void upsert(Figure figure) {
    _figures[figure.groupID] = figure;
  }

  Figure? getByID(int groupID) {
    return _figures[groupID];
  }

  List<Figure> getAll() {
    return _figures.values.toList();
  }

  List<Anchor> getByDatetime(DateTime searchDate) {
    final figureList = getAll();
    final concatedAnchors = <Anchor>[];
    for (final figure in figureList) {
      final matchingAnchors = figure.getByDatetime(searchDate);
      concatedAnchors.addAll(matchingAnchors);
    }
    return concatedAnchors;
  }
}
