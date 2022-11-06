import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/core/anchor.dart';
import 'package:grapher_user_draw/core/anchor_2d.dart';
import 'package:grapher_user_draw/core/anchor_group.dart';
import 'package:grapher_user_draw/logic/user_interaction.dart';
import 'package:grapher_user_draw/logic/virtual_coord.dart';

import '../misc/generator.dart';

void main() {
  testExpectedPoint();
  testChangementNeededFunction();
  testAddingAnchorToGroup();
  testEditAnAnchor();
  testHitObject();
}

void testExpectedPoint() {
  group('Test AnchorGroup expected points with: ', () {
    test("too few points", () {
      expect(() => GroupRulesTester(1), throwsException);
    });
    test("minimum expected points", () {
      expect(GroupRulesTester(2), isNot(throwsException));
    });
  });
}

void testChangementNeededFunction() {
  group('Test AnchorGroup changement needed when: ', () {
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

void testAddingAnchorToGroup() {
  group('Test adding a point to the group when: ', () {
    test('group is not full', () {
      final group = generateGroup(expectedPoint: 3, presentPoint: 2);
      expect(group.length, equals(2));
      group.add(generateAnchor());
      expect(group.length, equals(3));
    });
    test('group is full', () {
      final group = generateGroup(expectedPoint: 3, presentPoint: 3);
      expect(() => group.add(generateAnchor()), throwsException);
    });
  });
}

void testEditAnAnchor() {
  test('Test AnchorGroup when an internal anchor is updated', () {
    final group = generateGroup(expectedPoint: 9, presentPoint: 3);
    expect(() {
      group.anchorList[1] = generateAnchor();
    }, returnsNormally);
  });
}

void testHitObject() {
  group('Test returned hit object by AnchorGroup when:', () {
    final grp = generateGroup(
        expectedPoint: 7,
        presentPoint: 5,
        xBase: DateTime(2022, 11, 06, 15),
        interval: const Duration(minutes: 2));
    test('coord is pointing to an anchor', () {
      final tapX = DateTime(2022, 11, 06, 15, 04);
      const double tapY = 999;
      final tapCoord = VirtualCoord(x: tapX, y: tapY);
      grp.anchorList[2] = updateAnchorWithY(grp.anchorList[2], tapY);
      final hitAnchor = grp.getHitObject(tapCoord) as Anchor2D?;
      expect(hitAnchor, isNotNull);
      expect(hitAnchor?.x, equals(tapX));
      expect(hitAnchor?.y, equals(tapY));
      expect(hitAnchor?.groupID, equals(1234));
    });
    test('coord is pointing to nothing', () {
      final tapX = DateTime(2022, 11, 06, 18, 04);
      final tapCoord = VirtualCoord(x: tapX, y: 145);
      expect(grp.getHitObject(tapCoord)?.x, isNull);
    });
  });
}

Anchor2D updateAnchorWithY(Anchor original, double y) {
  return Anchor2D(original.groupID, original.x, y);
}
