import 'package:grapher/kernel/drawEvent.dart';

import 'draw_tool_interface.dart';
import 'figure.dart';

class DrawPresenter {
  final DrawToolInterface _tool;
  DrawEvent? _drawEvent;

  DrawPresenter({required DrawToolInterface tool}) : _tool = tool;

  void onDrawEvent(DrawEvent event) {
    _drawEvent = event;
  }

  void draw(Figure figure) {
    if (_drawEvent == null) return;
    _tool.draw(_drawEvent!, figure);
  }
}
