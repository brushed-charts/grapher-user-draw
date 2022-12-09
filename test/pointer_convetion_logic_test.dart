import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/pointer_convertion_logic.dart';
import 'package:grapher_user_draw/virtual_coord.dart';
import 'package:mocktail/mocktail.dart';

class MockCoordTranslater extends Mock implements CoordTranslater {}

class MockRect extends Mock implements Rect {}

void main() {
  registerFallbackValue(Offset.zero);
  const radomPixelPosition = Offset(10, 30);
  final expectedVirtualCoord = VirtualCoord(DateTime(2022, 12, 09), 12);
  final mockZonePointable = MockRect();
  final mockCoordTranslater = MockCoordTranslater();
  late PointerConvertionLogic converter;

  setUp(() {
    converter = PointerConvertionLogic();
    when(() => mockZonePointable.contains(any())).thenReturn(true);
    when(() => mockCoordTranslater.toVirtual(any()))
        .thenReturn(expectedVirtualCoord);
  });

  test("Check convertion from pixel to virtual coord", () {
    converter.refresh(mockCoordTranslater, mockZonePointable);
    final resultingVirtualCoord = converter.toVirtual(radomPixelPosition);
    expect(resultingVirtualCoord, equals(expectedVirtualCoord));
  });

  group("Assert StateError is thrown during pointer convertion when", () {
    test("zone pointable is null", () {
      converter.refresh(mockCoordTranslater, null);
      expect(() => converter.toVirtual(radomPixelPosition), throwsStateError);
    });
    test("when refresh is not called", () {
      expect(() => converter.toVirtual(radomPixelPosition), throwsStateError);
    });
  });
}
