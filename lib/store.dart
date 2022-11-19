import 'figure.dart';

class FigureStore {
  final _figures = <int, Figure>{};
  int get length => _figures.length;

  void add(Figure figure) {
    _figures[figure.groupID] = figure;
  }

  Figure? getByID(int groupID) {
    return _figures[groupID];
  }
}
