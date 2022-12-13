import '../figure.dart';
import 'draw_info.dart';

abstract class DrawToolInterface {
  abstract int maxLength;
  abstract String name;
  draw(DrawInfo drawInfo, Figure figure);
}
