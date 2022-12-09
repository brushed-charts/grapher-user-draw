import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher_user_draw/user_interaction/bypass_pointer_event.dart';

class MockPointerPropagator extends GraphObject with SinglePropagator {
  MockPointerPropagator({required GraphObject child}) {
    this.child = child;
  }
  void propagatePointerEvent() {
    propagate(TapDownDetails());
    propagate(TapUpDetails(kind: PointerDeviceKind.mouse));
    propagate(DragDownDetails());
    propagate(DragUpdateDetails(globalPosition: Offset.zero));
    propagate(DragStartDetails());
    propagate(DragEndDetails());
  }
}

class PointerReceptorTester extends GraphObject with SinglePropagator {
  bool isPointerEventCalled = false;
  PointerReceptorTester({GraphObject? child}) {
    this.child = child;
    eventRegistry.add(TapDownDetails, (p0) => onPointerEvent(p0));
    eventRegistry.add(TapUpDetails, (p0) => onPointerEvent(p0));
    eventRegistry.add(DragDownDetails, (p0) => onPointerEvent(p0));
    eventRegistry.add(DragUpdateDetails, (p0) => onPointerEvent(p0));
    eventRegistry.add(DragStartDetails, (p0) => onPointerEvent(p0));
    eventRegistry.add(DragEndDetails, (p0) => onPointerEvent(p0));
  }
  void onPointerEvent(e) {
    isPointerEventCalled = true;
  }
}

void main() {
  late PointerReceptorTester receptor, subChild;
  late PointerEventBypassChild bypass;
  late MockPointerPropagator propagator;

  setUp(() {
    subChild = PointerReceptorTester();
    receptor = PointerReceptorTester(child: subChild);
    bypass = PointerEventBypassChild(child: receptor);
    propagator = MockPointerPropagator(child: bypass);
  });
  test(
      "Check that pointer event, passes throught "
      "the bypass' child when the bypass is disabled", () {
    bypass.disable();
    propagator.propagatePointerEvent();
    expect(receptor.isPointerEventCalled, isTrue);
  });

  group("when bypass is enable", () {
    test("check bypass' child doesn't receives pointer event ", () {
      bypass.enable();
      propagator.propagatePointerEvent();
      expect(receptor.isPointerEventCalled, isFalse);
    });

    test("check bypass' subchild still receives pointer event", () {
      bypass.enable();
      propagator.propagatePointerEvent();
      expect(subChild.isPointerEventCalled, isTrue);
    });
  });

  test("is_enabled", () {});
}
