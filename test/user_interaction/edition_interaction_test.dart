import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/view/axis/virtual-axis.dart';
import 'package:grapher_user_draw/anchor.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/figure.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/edition_interaction.dart';
import 'package:grapher_user_draw/virtual_coord.dart';
import 'package:mocktail/mocktail.dart';

import '../figure_store_test.dart';
import 'gesture_interpreter_test.dart';

class MockVirtualAxis extends Mock implements VirtualAxis {}

class MockCoordTranslator extends Mock implements CoordTranslater {}

class MockStore extends Mock implements FigureStore {}

class MockFigure extends Mock implements Figure {
  @override
  int groupID = 1234;
}

void main() {
  late MockFigureDatabase mockDatabase;
  late EditionInteraction edition;

  final mockStore = MockStore();
  final mockFigure = MockFigure();
  final mockSelectionCondition = MockAnchorSelectionCondition();

  final randomPickedDate = DateTime(2022, 12, 04);
  const double randomMockValue1 = 1.7796;
  const double randomMockValue2 = 1.8796;
  const double randomMockValue3 = 1.8756;
  final pointerPosition = VirtualCoord(randomPickedDate, randomMockValue3);
  final dragEndPosition = VirtualCoord(DateTime(2022, 12, 05), 12.896);

  final anchorA = Anchor(x: randomPickedDate, y: randomMockValue1);
  final anchorB = Anchor(x: randomPickedDate, y: randomMockValue2);
  registerFallbackValue(Anchor(x: DateTime.now(), y: 0));
  registerFallbackValue(Figure(MockDrawTool(1)));
  late Function() checkAnchorAForSelection;
  late Function() checkAnchorBForSelection;

  setUp(() {
    mockDatabase = MockFigureDatabase();
    edition = EditionInteraction(
        mockStore, mockSelectionCondition, MockReferenceReader(), mockDatabase);

    checkAnchorAForSelection =
        () => mockSelectionCondition.isCloseToPointer(any(), anchorA.y);
    checkAnchorBForSelection =
        () => mockSelectionCondition.isCloseToPointer(any(), anchorB.y);

    when(() => mockStore.getByDatetime(any())).thenReturn([anchorA, anchorB]);
    when(checkAnchorAForSelection).thenReturn(false);
    when(checkAnchorBForSelection).thenReturn(false);
    when(() => mockStore.getByAnchor(any())).thenReturn(mockFigure);
    when(() => mockStore.getAll()).thenReturn([]);
  });

  group("Test selectedAnchor when anchor selection condition", () {
    test("is matched for one anchor during Tap and drag", () {
      when(checkAnchorAForSelection).thenReturn(false);
      when(checkAnchorBForSelection).thenReturn(true);

      edition.onTap(pointerPosition);
      expect(edition.anchorSelected, equals(anchorB));
      edition.onDragStart(pointerPosition);
      expect(edition.anchorSelected, equals(anchorB));
    });

    test("match with no anchor during Tap and drag", () {
      when(checkAnchorAForSelection).thenReturn(false);
      when(checkAnchorBForSelection).thenReturn(false);

      edition.onTap(pointerPosition);
      expect(edition.anchorSelected, isNull);
      edition.onDragStart(pointerPosition);
      expect(edition.anchorSelected, equals(isNull));
    });
  });

  group("During drag, assert stored and selected anchor", () {
    test("moved to the target", () {
      when(checkAnchorBForSelection).thenReturn(true);
      final targetAnchor = Anchor(x: dragEndPosition.x, y: dragEndPosition.y);
      edition.onDragStart(pointerPosition);
      edition.onDrag(dragEndPosition);
      expect(edition.anchorSelected, isNotNull);
      expect(edition.anchorSelected!.x, equals(dragEndPosition.x));
      expect(edition.anchorSelected!.y, equals(dragEndPosition.y));
      verify(() => mockFigure.replace(anchorB, targetAnchor)).called(1);
    });
    test("do nothing if there is no anchor selected at first", () {
      edition.onDragStart(pointerPosition);
      edition.onDrag(dragEndPosition);
      expect(edition.anchorSelected, isNull);
      verifyNever(() => mockFigure.replace(any(), any()));
    });
  });

  test(
      "During edition on deletion trigger, "
      "expect the whole figure to be removed", () {
    when(checkAnchorBForSelection).thenReturn(true);
    edition.onTap(pointerPosition);
    edition.delete();
    verify(() => mockStore.delete(any())).called(1);
    expect(edition.anchorSelected, isNull);
  });

  group("About saving on edition, expect", () {
    test("anchor drag trigger database saves", () {
      when(checkAnchorBForSelection).thenReturn(true);
      edition.onDragStart(pointerPosition);
      edition.onDragEnd();
      edition.onDragStart(dragEndPosition);
      edition.onDragEnd();
      verify(() => mockDatabase.save(any())).called(2);
    });
    test("anchor deletion trigger database deletion function", () {
      when(checkAnchorBForSelection).thenReturn(true);
      edition.onTap(pointerPosition);
      edition.delete();
      verify(() => mockDatabase.delete(any())).called(1);
    });
  });
}
