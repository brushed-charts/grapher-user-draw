import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

void main() {
  testingEqualityOfVirtualCoord();
}

void testingEqualityOfVirtualCoord() {
  group('Test equality of VirtualCoord', () {
    final coord1 = VirtualCoord(DateTime(2022, 11, 14, 10, 00), 11.1);
    final coord2 = VirtualCoord(DateTime(2022, 11, 14, 10, 00), 239);
    final coord3 = VirtualCoord(DateTime(2022, 11, 10, 10, 00), 11.1);
    final coord4 = VirtualCoord(DateTime(2022, 11, 10, 10, 00), 765);
    test("using equality opearator", () {
      expect(coord1, equals(coord1));
      expect(coord1, isNot(equals(coord2)));
      expect(coord1, isNot(equals(coord3)));
      expect(coord1, isNot(equals(coord4)));
    });
    test('using hasCode', () {
      expect(coord1.hashCode, equals(coord1.hashCode));
      expect(coord1.hashCode, isNot(equals(coord2.hashCode)));
    });
  });
}
