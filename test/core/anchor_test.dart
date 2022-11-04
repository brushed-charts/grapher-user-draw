import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/core/anchor_2d.dart';

void main() {
  testAnchorString();
}

void testAnchorString() {
  test("test_anchor_to_string", () {
    final datetime = DateTime(2022, 11, 04, 18, 19);
    final anchor = Anchor2D(1234, datetime, 1.99);
    expect(anchor.toString(),
        equals('Anchor2D(group: 1234, x: 2022-11-04 18:19:00.000, y: 1.99)'));
  });
}
