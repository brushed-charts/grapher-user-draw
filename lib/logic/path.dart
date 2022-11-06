library grapher_user_draw;

import 'package:grapher_user_draw/logic/figure.dart';

class Path extends Figure {
  final String type;

  Path(this.type, super.expectedLength);
}
