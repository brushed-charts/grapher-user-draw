import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/anchor.dart';

void main() {
  testAnchorEquality();
}

void testAnchorEquality() {
  final expectedDatetime1 = DateTime(2022, 11, 19, 00, 50);
  final expectedDatetime2 = DateTime(2023, 11, 19, 00, 50);
  const double expectedY1 = 8765;
  const double expectedY2 = 8;
  final anchorA = Anchor(x: expectedDatetime1, y: expectedY1);

  test('Assert two anchors with the same values are equals', () {
    final anchorX = Anchor(x: expectedDatetime1, y: expectedY1);
    expect(anchorA, equals(anchorX));
  });
  test('Assert two anchors with different X & Y are not equal', () {
    final anchorX = Anchor(x: expectedDatetime2, y: expectedY2);
    expect(anchorX, isNot(equals(anchorA)));
  });
}
