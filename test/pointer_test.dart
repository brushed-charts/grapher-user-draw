import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/capture_pointer.dart';
import 'package:mocktail/mocktail.dart';

class MockTapDownDetails extends Mock implements TapDownDetails {}

class MockDragDetails extends Mock implements DragUpdateDetails {}

class MockDragEndDetails extends Mock implements DragEndDetails {}

void main() {
  testCapturePointerForTapDownEvent();
  testCapturePointerForDragEvent();
}

void testCapturePointerForTapDownEvent() {
  test("test if CapturePointerEvent succeed to capture tapDown event", () {
    const simulatedTapPosition = Offset(30, 100);
    final capturePointer = CapturePointer();
    final tapDownDetails = MockTapDownDetails();
    when(() => tapDownDetails.localPosition).thenReturn(simulatedTapPosition);
    capturePointer.onTapDown(tapDownDetails);
    expect(capturePointer.tapPos, equals(simulatedTapPosition));
  });
}

void testCapturePointerForDragEvent() {
  test("test if CapturePointerEvent succeed to capture Drag event", () {
    const deltaOffset = Offset(2, 3);
    const dragPosition = Offset(38, 12);
    final capturePointer = CapturePointer();
    final dragDetails = MockDragDetails();
    when(() => dragDetails.delta).thenReturn(deltaOffset);
    when(() => dragDetails.localPosition).thenReturn(dragPosition);
    capturePointer.onDrag(dragDetails);
    expect(capturePointer.drag?.delta, equals(deltaOffset));
    expect(capturePointer.drag?.localPosition, equals(dragPosition));
  });
}
