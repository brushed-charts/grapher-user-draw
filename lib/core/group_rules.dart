
library grapher_user_draw;

import 'anchor.dart';

abstract class GroupRules {
  static const minPointsPerGroup = 2;
  final anchorList = <Anchor>[];
  abstract final int id;
  final int expectedLength;

  GroupRules(this.expectedLength) {
    checkGroupValidity();
  }

  void checkGroupValidity() {
    if (expectedLength < minPointsPerGroup) {
      throw Exception("A group must have at least $minPointsPerGroup");
    }
  }

  add(Anchor anchor) {
    anchorList.add(anchor);
  }

  bool shouldChange() {
    if (anchorList.length == expectedLength) return true;
    return false;
  }
}
