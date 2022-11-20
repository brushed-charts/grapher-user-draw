import 'package:grapher/kernel/drawEvent.dart';

import 'figure.dart';

abstract class DrawToolInterface {
  abstract int maxLength;
  draw(DrawEvent drawEvent, Figure figure);
}
