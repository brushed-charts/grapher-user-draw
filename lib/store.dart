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
}
