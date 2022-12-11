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

  Figure? getByAnchor(Anchor reference) {
    final figureList = getAll();
    Figure? matchingFigure;
    try {
      matchingFigure =
          figureList.firstWhere((figure) => figure.contains(reference));
    } catch (e) {
      matchingFigure = null;
    }

    return matchingFigure;
  }

  void populate(List<Figure> figuresList) {
    _figures.clear();
    for (final figure in figuresList) {
      upsert(figure);
    }
  }

  void delete(int groupID) {
    _figures.remove(groupID);
  }
}
