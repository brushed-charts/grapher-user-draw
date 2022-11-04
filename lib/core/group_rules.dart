library grapher_user_draw;

import 'anchor.dart';

abstract class GroupRules {
  static const minPointsPerGroup = 2;
  abstract final int id;
  final anchorList = <Anchor>[];
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
    if (shouldChange()) {
      throw Exception('Group reach the limit length of $expectedLength');
    }
    anchorList.add(anchor);
  }

  bool shouldChange() {
    if (anchorList.length == expectedLength) return true;
    return false;
  }

  int get length => anchorList.length;
}
