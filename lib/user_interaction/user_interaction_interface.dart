import 'package:grapher_user_draw/virtual_coord.dart';

abstract class UserInteraction {
  void onTap(VirtualCoord coord);
  void onDrag(VirtualCoord coord);
}
