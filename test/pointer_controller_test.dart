import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/kernel/kernel.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher_user_draw/draw_tools/draw_tool_interface.dart';
import 'package:grapher_user_draw/entrypoint_viewable.dart';
import 'package:grapher_user_draw/gesture_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockGestureController extends Mock implements GestureController {}

class MockDrawTool extends Mock implements DrawToolInterface {}

class FakePointerPropagator extends GraphObject with SinglePropagator {
  FakePointerPropagator(GraphObject child) {
    this.child = child;
  }
  void propagateTapDown() => propagate(TapDownDetails());

  void propagateTapUp() =>
      propagate(TapUpDetails(kind: PointerDeviceKind.unknown));

  void propagateDragUpdate() =>
      propagate(DragUpdateDetails(globalPosition: Offset.zero));

  void propagateDragEnd() => propagate(DragEndDetails());
}

void main() {
  group('Test gesture transmition to interpreter', () {
    final mockDrawTool = MockDrawTool();
    when(() => mockDrawTool.maxLength).thenReturn(3);

    final mockcontroller = MockGestureController();
    final entrypoint = GrapherUserDraw(gestureController: mockcontroller);
    final fakePropagator = FakePointerPropagator(entrypoint);
    GraphKernel(child: fakePropagator);

    test('when gesture is drag', () {
      registerFallbackValue(DragUpdateDetails(globalPosition: Offset.zero));
      registerFallbackValue(DragEndDetails());
      fakePropagator.propagateDragUpdate();
      fakePropagator.propagateDragEnd();
      verify(() => mockcontroller.onDrag(captureAny())).called(1);
      verify(() => mockcontroller.onDragEnd(any())).called(1);
    });

    test('when gesture is TapUp', () {
      registerFallbackValue(TapUpDetails(kind: PointerDeviceKind.unknown));
      fakePropagator.propagateTapUp();
      verify(() => mockcontroller.onTapUp(captureAny())).called(1);
    });
  });
}
