import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher_user_draw/draw_tools/draw_info.dart';

import 'draw_tools/draw_tool_interface.dart';
import 'figure.dart';

class DrawPresenter {
  final DrawToolInterface _tool;

  DrawPresenter({required DrawToolInterface tool}) : _tool = tool;

  void draw(ViewEvent event, Figure figure) {
    final drawStruct = DrawInfo(event);
    _tool.draw(drawStruct, figure);
  }
}
