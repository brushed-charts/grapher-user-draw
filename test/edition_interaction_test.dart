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
  final mockStore = MockStore();
  final mockSelectionCondition = MockAnchorSelectionCondition();

  final randomPickedDate = DateTime(2022, 12, 04);
  const double randomMockValue1 = 1.7796;
  const double randomMockValue2 = 1.8796;
  const double randomMockValue3 = 1.8756;
  final pointerPosition = VirtualCoord(randomPickedDate, randomMockValue3);

  final anchorA = Anchor(x: randomPickedDate, y: randomMockValue1);
  final anchorB = Anchor(x: randomPickedDate, y: randomMockValue2);
  final edition = EditionInteraction(mockStore, mockSelectionCondition);

  when(() => mockStore.getByDatetime(any())).thenReturn([anchorA, anchorB]);
  checkAnchorA() => mockSelectionCondition.isCloseToPointer(any(), anchorA.y);
  checkAnchorB() => mockSelectionCondition.isCloseToPointer(any(), anchorB.y);
  when(checkAnchorA).thenReturn(false);
  when(checkAnchorB).thenReturn(false);

  group("Test selectedAnchor when anchor selection condition", () {
    test("is matched for one anchor during Tap and drag", () {
      when(checkAnchorA).thenReturn(false);
      when(checkAnchorB).thenReturn(true);

      edition.onTap(pointerPosition);
      expect(edition.anchorSelected, equals(anchorB));

      edition.onDragStart(pointerPosition);
      expect(edition.anchorSelected, equals(anchorB));
    });

    test("match with no anchor during Tap and drag", () {
      when(checkAnchorA).thenReturn(false);
      when(checkAnchorB).thenReturn(false);

      edition.onTap(pointerPosition);
      expect(edition.anchorSelected, isNull);

      edition.onDragStart(pointerPosition);
      expect(edition.anchorSelected, equals(isNull));
    });
  });

  test("During drag assert selected anchor moved to the target ", () {
    when(checkAnchorB).thenReturn(true);
    final finalPointerPosition = VirtualCoord(DateTime(2022, 12, 05), 12.896);
    edition.onDragStart(pointerPosition);
    edition.onDrag(finalPointerPosition);
    expect(edition.anchorSelected, isNotNull);
    expect(edition.anchorSelected!.x, equals(finalPointerPosition.x));
    expect(edition.anchorSelected!.y, equals(finalPointerPosition.y));
  });
}
