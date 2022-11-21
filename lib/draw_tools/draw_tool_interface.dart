import 'dart:ui';

import '../figure.dart';
import 'draw_info.dart';

abstract class DrawToolInterface {
  abstract int maxLength;
  draw(DrawInfo drawInfo, Figure figure);
}
