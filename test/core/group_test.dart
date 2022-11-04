import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/core/anchor.dart';
import 'package:grapher_user_draw/core/anchor_2d.dart';
import 'package:grapher_user_draw/core/group_rules.dart';

class GroupRulesTester extends GroupRules {
  final id = Random().nextInt(100);
  GroupRulesTester(int expectedPoints) : super(expectedPoints);
}

void main() {
  testExpectedPoint();
  testChangementNeededFunction();
}

void testExpectedPoint() {
  group('test AnchorGroup expected points with', () {
    test("too few points", () {
      expect(() => GroupRulesTester(1), throwsException);
    });
    test("minimum expected points", () {
      expect(GroupRulesTester(2), isNot(throwsException));
    });
  });
}

void testChangementNeededFunction() {
  group('test AnchorGroup changement needed when', () {
    test("group is full", () {
      final groupFull = generateGroup(expectedPoint: 7, presentPoint: 7);
      expect(groupFull.shouldChange(), equals(true));
    });

    test("group is partially filled", () {
      final groupPartial = generateGroup(expectedPoint: 7, presentPoint: 3);
      expect(groupPartial.shouldChange(), equals(false));
    });
  });
}

GroupRules generateGroup(
    {required int expectedPoint, required int presentPoint}) {
  final group = GroupRulesTester(expectedPoint);
  for (var i = 0; i < presentPoint; i++) {
    final anchor = generateAnchor();
    group.add(anchor);
  }
  return group;
}

Anchor generateAnchor() {
  const groupID = 1234;
  final y = Random.secure().nextDouble();
  final anchor = Anchor2D(groupID, DateTime.now(), y);
  return anchor;
}
