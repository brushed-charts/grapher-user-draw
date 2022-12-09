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
  const pointerInsideZone = Offset(11, 30);
  const pointerOutsideZone = Offset(200, 30);
  final expectedVirtualCoord = VirtualCoord(DateTime(2022, 12, 09), 12);
  final zonePointable = const Offset(10, 10) & const Size(100, 100);
  final mockCoordTranslater = MockCoordTranslater();
  late PointerConvertionLogic converter;

  setUp(() {
    converter = PointerConvertionLogic();
    when(() => mockCoordTranslater.toVirtual(any()))
        .thenReturn(expectedVirtualCoord);
  });

  test("Check convertion from pixel to virtual coord", () {
    converter.refresh(mockCoordTranslater, zonePointable);
    final resultingVirtualCoord = converter.toVirtual(pointerInsideZone);
    expect(resultingVirtualCoord, equals(expectedVirtualCoord));
  });

  group("Assert StateError is thrown during pointer convertion when", () {
    test("zone pointable is null", () {
      converter.refresh(mockCoordTranslater, null);
      expect(() => converter.toVirtual(pointerInsideZone), throwsStateError);
    });
    test("when refresh is not called", () {
      expect(() => converter.toVirtual(pointerInsideZone), throwsStateError);
    });
  });

  group('When pointer is out of the pointable zone', () {
    test('expect the convertion to virtual return null', () {
      converter.refresh(mockCoordTranslater, zonePointable);
      final resultingVirtualCoord = converter.toVirtual(pointerOutsideZone);
      expect(resultingVirtualCoord, isNull);
    });
  });
}
