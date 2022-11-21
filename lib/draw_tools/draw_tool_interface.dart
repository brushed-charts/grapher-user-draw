import 'dart:ui';

import '../figure.dart';

abstract class DrawToolInterface {
  abstract int maxLength;
  draw(Canvas canvas, Figure figure);
}
