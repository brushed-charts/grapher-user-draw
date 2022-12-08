import 'package:grapher_user_draw/draw_tools/draw_tool_interface.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/tap_interaction_interface.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

import 'package:grapher_user_draw/anchor.dart';
import 'package:grapher_user_draw/figure.dart';

class CreationInteraction implements TapInteractionInterface {
  final FigureStore _store;
  Figure? _currentFigure;
  final DrawToolInterface tool;
  int get figureLength => tool.maxLength;

  CreationInteraction(this.tool, this._store);

  @override
  void onTap(VirtualCoord coord) {
    _initFigureIfNeeded();
    _currentFigure!.add(Anchor(x: coord.x, y: coord.y));
    _store.upsert(_currentFigure!);
  }

  void _initFigureIfNeeded() {
    final shouldBeInit = _currentFigure?.isFull() ?? true;
    if (!shouldBeInit) return;
    _currentFigure = Figure(tool);
  }
}
