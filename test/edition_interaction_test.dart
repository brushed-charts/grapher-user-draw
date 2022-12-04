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
  group("Test selectedAnchor when anchor selection condition", () {
    final mockStore = MockStore();
    final mockSelectionCondition = MockAnchorSelectionCondition();

    final randomPickedDate = DateTime(2022, 12, 04);
    const double randomMockValue1 = 1.7796;
    const double randomMockValue2 = 1.8796;
    const double randomMockValue3 = 1.8756;

    final anchorA = Anchor(x: randomPickedDate, y: randomMockValue1);
    final anchorB = Anchor(x: randomPickedDate, y: randomMockValue2);
    final edition = EditionInteraction(mockStore, mockSelectionCondition);

    when(() => mockStore.getByDatetime(any())).thenReturn([anchorA, anchorB]);
    selectionA() => mockSelectionCondition.isCloseToPointer(any(), anchorA.y);
    selectionB() => mockSelectionCondition.isCloseToPointer(any(), anchorB.y);

    test("is matched for one anchor", () {
      when(selectionA).thenReturn(false);
      when(selectionB).thenReturn(true);

      edition.onTap(VirtualCoord(randomPickedDate, randomMockValue3));
      expect(edition.anchorSelected, equals(anchorB));
    });

    test("match with no anchor", () {
      when(selectionA).thenReturn(false);
      when(selectionB).thenReturn(false);

      edition.onTap(VirtualCoord(randomPickedDate, randomMockValue3));
      expect(edition.anchorSelected, isNull);
    });
  });
}
