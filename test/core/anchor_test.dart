import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/core/anchor_2d.dart';
import 'package:grapher_user_draw/core/virtual_coord_interface.dart';

class VirtualCoordTester implements VirtualCoordInterface {
  final DateTime x;
  final double y;
  VirtualCoordTester(this.x, this.y);
}

void main() {
  testAnchorString();
  testAnchorHit();
}

void testAnchorString() {
  test("test anchor to string", () {
    final datetime = DateTime(2022, 11, 04, 18, 19);
    final anchor = Anchor2D(1234, datetime, 1.99);
    expect(anchor.toString(),
        equals('Anchor2D(group: 1234, x: 2022-11-04 18:19:00.000, y: 1.99)'));
  });
}

void testAnchorHit() {
  group("test anchor hit when: ", () {
    final datetime = DateTime(2022, 11, 04, 18, 19);
    final anchor = Anchor2D(1234, datetime, 1.99);
    test('hit should be activate', () {
      final tapX = DateTime(2022, 11, 04, 18, 19);
      final tapCoord = VirtualCoordTester(tapX, 1.99);
      expect(anchor.isHit(tapCoord), equals(true));
    });

    test('hit should be activate using rounding', () {
      final tapCoord = VirtualCoordTester(datetime, 7);
      expect(anchor.isHit(tapCoord), equals(true));
    });

    test('hit should not be activate because Y is too far', () {
      final tapCoord = VirtualCoordTester(datetime, 115);
      expect(anchor.isHit(tapCoord), equals(false));
    });

    test('hit should not be activate because X is too far', () {
      final tapX = DateTime(2022, 11, 04, 18, 30);
      final tapCoord = VirtualCoordTester(tapX, 2);
      expect(anchor.isHit(tapCoord), equals(false));
    });
  });
}
