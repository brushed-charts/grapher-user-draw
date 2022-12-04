import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/view/axis/virtual-axis.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/user_interaction/anchor_selection_condition.dart';
import 'package:mocktail/mocktail.dart';

class MockVirtualAxis extends Mock implements VirtualAxis {}

class MockCoordTranslator extends Mock implements CoordTranslater {
  @override
  final yAxis = MockVirtualAxis();
}

void main() {
  const anyVirtualTapPos = 1.986;
  const anyVirtualAnchorPos = 1.95;
  const double tapPixelPosition = 27;
  const double wantedAnchorPixelPositionA = 25;
  const double wantedAnchorPixelPositionB = 5;

  final mockCoordTranslater = MockCoordTranslator();
  final selectionCondition = AnchorYSelectionCondition();
  selectionCondition.updateCoordTranslater(mockCoordTranslater);
  when(() => mockCoordTranslater.yAxis.toPixel(anyVirtualTapPos))
      .thenReturn(tapPixelPosition);

  test("When pointer tap close to an anchor expect it can be selectable", () {
    when(() => mockCoordTranslater.yAxis.toPixel(anyVirtualAnchorPos))
        .thenReturn(wantedAnchorPixelPositionA);
    final isSelectable = selectionCondition.isCloseToPointer(
        anyVirtualTapPos, anyVirtualAnchorPos);
    expect(isSelectable, isTrue);
  });
  test(
      "When pointer tap is too far from anchor"
      "expect it is not selectable", () {
    when(() => mockCoordTranslater.yAxis.toPixel(anyVirtualAnchorPos))
        .thenReturn(wantedAnchorPixelPositionB);
    final isSelectable = selectionCondition.isCloseToPointer(
        anyVirtualTapPos, anyVirtualAnchorPos);
    expect(isSelectable, isFalse);
  });
}
