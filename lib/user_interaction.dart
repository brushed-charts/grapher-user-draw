import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

import 'anchor.dart';
import 'figure.dart';

class UserInteraction {
  final FigureStore _store;
  Figure? _currentFigure;
  final int figureLength;

  UserInteraction(this.figureLength, [FigureStore? store])
      : _store = store ?? FigureStore();

  void onTap(VirtualCoord coord) {
    _initFigureIfNeeded();
    _currentFigure!.add(Anchor(x: coord.x, y: coord.y));
    _store.upsert(_currentFigure!);
  }

  void _initFigureIfNeeded() {
    final shouldBeInit = _currentFigure?.isFull() ?? true;
    if (!shouldBeInit) return;
    _currentFigure = Figure(figureLength);
  }

  void onDrag(VirtualCoord coord) {}
}
