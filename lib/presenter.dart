import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher_user_draw/draw_tools/draw_info.dart';
import 'package:grapher_user_draw/draw_tools/draw_tool_event.dart';
import 'package:grapher_user_draw/store.dart';

import 'draw_tools/draw_tool_interface.dart';
import 'figure.dart';

class DrawPresenter extends GraphObject with EndlinePropagator {
  DrawToolInterface? _tool;
  final FigureStore _store;
  late DrawInfo drawInfo;

  DrawPresenter(this._store) {
    eventRegistry.add(DrawToolEvent, (p0) => _onDrawToolEvent(p0));
  }

  void _onDrawToolEvent(DrawToolEvent event) {
    _tool = event.tool;
  }

  void draw(ViewEvent event) {
    drawInfo = DrawInfo(event);
    _store.getAll().forEach((figure) {
      _drawFigure(figure);
    });
  }

  void _drawFigure(Figure figure) {
    _tool?.draw(drawInfo, figure);
  }
}
