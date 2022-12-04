import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/view/axis/virtual-axis.dart';
import 'package:grapher_user_draw/anchor.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/user_interaction/edition_interaction.dart';
import 'package:grapher_user_draw/virtual_coord.dart';
import 'package:mocktail/mocktail.dart';

import 'gesture_controller_test.dart';
import 'presenter_test.dart';

class MockVirtualAxis extends Mock implements VirtualAxis {}

class MockCoordTranslator extends Mock implements CoordTranslater {}

void main() {
  group("In edition interaction on Tap expect the selected anchor", () {
    registerFallbackValue(DateTime.now());
    final date = DateTime(2022, 12, 04);
    final anchorA = Anchor(x: date, y: 1.875);
    final anchorB = Anchor(x: date, y: 1.957);
    final tapVirtualPosition = VirtualCoord(date, 1.952);
    const double anchorACorrespondingPixel = 0;
    const double anchorBCorrespondingPixel = 30;
    final mockStore = MockStore();
    final mockCoordTranslater = MockCoordTranslator();
    final mockVirtualAxis = MockVirtualAxis();

    when(() => mockCoordTranslater.yAxis).thenReturn(mockVirtualAxis);
    when(() => mockStore.getByDatetime(any())).thenReturn([anchorA, anchorB]);
    when(() => mockVirtualAxis.toPixel(anchorA.y))
        .thenReturn(anchorACorrespondingPixel);
    when(() => mockVirtualAxis.toPixel(anchorB.y))
        .thenReturn(anchorBCorrespondingPixel);
    test("is not null when tap Y position is close to an anchor", () {
      final edition = EditionInteraction(mockStore, null);
      const double tapPositionInPixel = 27;
      when(() => mockVirtualAxis.toPixel(tapVirtualPosition.y))
          .thenReturn(tapPositionInPixel);
      edition.updateCoordTranslater(mockCoordTranslater);
      edition.onTap(tapVirtualPosition);
      // expect(edition.anchorSelected, equals(anchorB));
    });
    test("is null when tap Y position is too far from any anchor", () {
      final edition = EditionInteraction(mockStore, null);
      edition.onTap(VirtualCoord(date, 630));
      expect(edition.anchorSelected, isNull);
    });
  });
}
