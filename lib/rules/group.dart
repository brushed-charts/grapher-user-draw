library grapher_user_draw;

import 'package:grapher_user_draw/utils/misc_functions.dart';

import '../core/anchor.dart';

abstract class AnchorGroup {
  final anchorList = <Anchor>[];
  final id = Misc.generateUniqueID;
  final int expectedLength;

  AnchorGroup(this.expectedLength);

  add(Anchor anchor) {
    anchorList.add(anchor);
  }
}
