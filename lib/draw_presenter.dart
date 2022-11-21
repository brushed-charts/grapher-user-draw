import 'package:grapher/kernel/drawEvent.dart';

import 'draw_tools/draw_tool_interface.dart';
import 'figure.dart';

class DrawPresenter {
  final DrawToolInterface _tool;

  DrawPresenter({required DrawToolInterface tool}) : _tool = tool;

  void draw(DrawEvent event, Figure figure) {
    _tool.draw(event.canvas, figure);
  }
}
