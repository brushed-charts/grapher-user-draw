import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/anchor.dart';

void main() {
  final expectedDatetime1 = DateTime(2022, 11, 19, 00, 50);
  final expectedDatetime2 = DateTime(2023, 11, 19, 00, 50);
  const double expectedY1 = 8765;
  const double expectedY2 = 8;
  final anchorA = Anchor(x: expectedDatetime1, y: expectedY1);

  test('Assert two anchors with the same values are equals', () {
    final anchorX = Anchor(x: DateTime(2022, 11, 19, 00, 50), y: 8765);
    expect(anchorA, equals(anchorX));
    expect(anchorA.hashCode, equals(anchorX.hashCode));
  });
  test('Assert two anchors with different X & Y are not equal', () {
    final anchorX = Anchor(x: expectedDatetime2, y: expectedY2);
    expect(anchorX, isNot(equals(anchorA)));
  });

  group("Expect Anchor's hash code to be", () {
    test("the same when anchors are equal", () {
      final anchorMirror = Anchor(x: expectedDatetime1, y: expectedY1);
      expect(anchorA.hashCode, equals(anchorMirror.hashCode));
    });
    test("different when anchor have different data", () {
      final anchorDifferent = Anchor(x: expectedDatetime2, y: expectedY1);
      assert(anchorA.hashCode != anchorDifferent.hashCode);
    });
  });
}
