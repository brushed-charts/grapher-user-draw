import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/view/axis/unit-axis.dart';
import 'package:grapher/view/axis/virtual-axis.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/virtual_coord.dart';
import 'package:mocktail/mocktail.dart';

class MockUnitAxis extends Mock implements UnitAxis {}

class MockVirtualAxis extends Mock implements VirtualAxis {}

void main() {
  CoordTranslateTester().testConvertionPixelToVirtual();
  CoordTranslateTester().testConvertionVirtualToPixel();
}

class CoordTranslateTester {
  late final VirtualCoord virtualCoord;
  final pointerCoord = const Offset(10, 20);
  late final CoordTranslater translater;
  final virtualY = 1.78909;
  final virtualX = DateTime(2022, 11, 14);
  final mockUnitAxis = MockUnitAxis();
  final mockVirtualAxis = MockVirtualAxis();

  CoordTranslateTester() {
    virtualCoord = VirtualCoord(virtualX, virtualY);
    translater = CoordTranslater(mockUnitAxis, mockVirtualAxis);
  }

  void testConvertionPixelToVirtual() {
    group('Test Translation from pixel coord to virtual', () {
      when(() => mockVirtualAxis.toVirtual(pointerCoord.dy))
          .thenReturn(virtualCoord.y);

      test("using mock axis", () {
        when(() => mockUnitAxis.toVirtual(pointerCoord.dx))
            .thenReturn(virtualCoord.x);
        expect(translater.toVirtual(pointerCoord), equals(virtualCoord));
      });

      test("with mock Xaxis returning null", () {
        final translater = CoordTranslater(mockUnitAxis, mockVirtualAxis);
        when(() => mockUnitAxis.toVirtual(pointerCoord.dx)).thenReturn(null);
        expect(translater.toVirtual(pointerCoord), equals(null));
      });
    });
  }

  void testConvertionVirtualToPixel() {
    group('Test Translation from virtual to pixel coord', () {
      when(() => mockVirtualAxis.toPixel(virtualY)).thenReturn(pointerCoord.dy);

      test('using mock axis', () {
        when(() => mockUnitAxis.toPixel(virtualX)).thenReturn(pointerCoord.dx);
        expect(translater.toPixel(virtualCoord), pointerCoord);
      });

      test('with mock x axis returning null', () {
        when(() => mockUnitAxis.toPixel(virtualCoord.x)).thenReturn(null);
      });
    });
  }
}
