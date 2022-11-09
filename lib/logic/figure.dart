import 'package:grapher_user_draw/core/anchor_group.dart';
import 'package:grapher_user_draw/utils/misc_functions.dart';

import '../core/anchor.dart';

abstract class Figure<T extends Anchor> extends AnchorGroup<T> {
  int id = Misc.generateUniqueID();

  Figure(super.expectedLength);
  draw();
}
