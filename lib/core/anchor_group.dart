library grapher_user_draw;

import 'package:grapher_user_draw/core/virtual_coord_interface.dart';

import 'anchor.dart';

abstract class AnchorGroup<T extends Anchor> {
  static const minPointsPerGroup = 2;
  abstract final int id;
  final anchorList = <T>[];
  final int expectedLength;

  AnchorGroup(this.expectedLength) {
    checkGroupValidity();
  }

  void checkGroupValidity() {
    if (expectedLength < minPointsPerGroup) {
      throw Exception("A group must have at least $minPointsPerGroup");
    }
  }

  add(T anchor) {
    if (shouldChange()) {
      throw Exception('Group reach the limit length of $expectedLength');
    }
    anchorList.add(anchor);
  }

  bool shouldChange() {
    if (anchorList.length == expectedLength) return true;
    return false;
  }

  T? getHitObject(VirtualCoordInterface coord) {
    for (final anchor in anchorList) {
      if (anchor.isHit(coord)) return anchor;
    }
    return null;
  }

  bool shouldDelete() {
    if (length == 0) return true;
    return false;
  }

  int get length => anchorList.length;
}
