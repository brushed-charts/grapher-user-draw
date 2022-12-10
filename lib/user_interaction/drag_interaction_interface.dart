import 'package:grapher_user_draw/virtual_coord.dart';

abstract class DragInteractionInterface {
  void onDragStart(VirtualCoord coord);
  void onDrag(VirtualCoord coord);
  void onDragEnd();
}
