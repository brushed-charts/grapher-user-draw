import 'package:grapher_user_draw/core/virtual_coord_interface.dart';

class VirtualCoord implements VirtualCoordInterface {
  @override
  final DateTime x;
  @override
  final double y;

  VirtualCoord({required this.x, required this.y});
}
