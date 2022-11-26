import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/kernel/kernel.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher_user_draw/entrypoint_viewable.dart';
import 'package:grapher_user_draw/gesture_controller.dart';
import 'package:grapher_user_draw/refresh_service.dart';
import 'package:mocktail/mocktail.dart';

class MockGestureController extends Mock implements GestureController {}

class FakePointerPropagator extends GraphObject with SinglePropagator {
  FakePointerPropagator(GraphObject child) {
    this.child = child;
  }
  void propagateTapDown() => propagate(TapDownDetails());

  void propagateTapUp() =>
      propagate(TapUpDetails(kind: PointerDeviceKind.unknown));

  void propagateDragUpdate() =>
      propagate(DragUpdateDetails(globalPosition: Offset.zero));
}

void main() {
  test('not throw when GrapherUserDraw is called before', () {
    final entrypoint = GrapherUserDraw();
    expect(() => RefreshService.refresh(), returnsNormally);
  });
  testGestureTransmitionToInterpreter();
}

void testGestureTransmitionToInterpreter() {
  group('Test gesture transmition to interpreter', () {
    final mockcontroller = MockGestureController();
    final entrypoint = GrapherUserDraw(gestureController: mockcontroller);
    final fakePropagator = FakePointerPropagator(entrypoint);
    GraphKernel(child: fakePropagator);

    test('when gesture is a tapDown', () {
      registerFallbackValue(TapDownDetails());
      fakePropagator.propagateTapDown();
      verify(() => mockcontroller.onTapDown(captureAny())).called(1);
    });

    test('when gesture is dragDown', () {
      registerFallbackValue(DragUpdateDetails(globalPosition: Offset.zero));
      fakePropagator.propagateDragUpdate();
      verify(() => mockcontroller.onDrag(captureAny())).called(1);
    });

    test('when gesture is TapUp', () {
      registerFallbackValue(TapUpDetails(kind: PointerDeviceKind.unknown));
      fakePropagator.propagateTapUp();
      verify(() => mockcontroller.onTapUp(captureAny())).called(1);
    });
  });
}
