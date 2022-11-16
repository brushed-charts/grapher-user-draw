import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/gesture_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockTapDownDetails extends Mock implements TapDownDetails {}

class MockDragDetails extends Mock implements DragUpdateDetails {}

class MockDragEndDetails extends Mock implements DragEndDetails {}

void main() {
  testControllerForTapDownEvent();
  testControllerForDragEvent();
}

void testControllerForTapDownEvent() {
  test("test if CapturePointerEvent succeed to capture tapDown event", () {
    const simulatedTapPosition = Offset(30, 100);
    final controller = GestureController();
    final tapDownDetails = MockTapDownDetails();
    when(() => tapDownDetails.localPosition).thenReturn(simulatedTapPosition);
    controller.onTapDown(tapDownDetails);
    expect(controller.pointerCoord, equals(simulatedTapPosition));
  });
}

void testControllerForDragEvent() {
  test("test if CapturePointerEvent succeed to capture Drag event", () {
    const dragPosition = Offset(38, 12);
    final controller = GestureController();
    final dragDetails = MockDragDetails();
    when(() => dragDetails.localPosition).thenReturn(dragPosition);
    controller.onDrag(dragDetails);
    expect(controller.pointerCoord, equals(dragPosition));
  });
}
