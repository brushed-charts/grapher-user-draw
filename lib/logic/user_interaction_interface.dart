import 'package:grapher_user_draw/logic/virtual_coord.dart';

abstract class UserInteractionInterface {
  handleTap(VirtualCoord coord);
  handleDragStart(VirtualCoord coord);
  handleDrag(VirtualCoord coord);
  handleDragEnd(VirtualCoord coord);
}
