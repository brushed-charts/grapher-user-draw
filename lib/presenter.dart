import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/draw_tools/draw_info.dart';
import 'package:grapher_user_draw/store.dart';

import 'figure.dart';

class DrawPresenter extends Viewable with EndlinePropagator {
  final FigureStore _store;
  late DrawInfo drawInfo;

  DrawPresenter(this._store);

  @override
  void draw(ViewEvent viewEvent) {
    drawInfo = DrawInfo(viewEvent);
    _store.getAll().forEach((figure) {
      _drawFigure(figure);
    });
  }

  void _drawFigure(Figure figure) {
    final tool = figure.tool;
    tool.draw(drawInfo, figure);
  }
}
