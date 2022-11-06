import 'package:grapher_user_draw/core/anchor_group.dart';
import 'package:grapher_user_draw/utils/misc_functions.dart';

import '../core/anchor_2d.dart';

class Figure extends AnchorGroup<Anchor2D> {
  int id = Misc.generateUniqueID();

  Figure(super.expectedLength);
}
