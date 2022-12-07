import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher_user_draw/figure_deletion_interface.dart';
import 'package:grapher_user_draw/keyboard_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockDeletionTester extends Mock implements FigureDeletionInterface {}

class KeyEventPropagator extends GraphObject with SinglePropagator {
  KeyEventPropagator({required GraphObject child}) {
    this.child = child;
  }

  void emitKeyDownDelete() {
    const keyEvent = KeyDownEvent(
        physicalKey: PhysicalKeyboardKey.delete,
        logicalKey: LogicalKeyboardKey.delete,
        timeStamp: Duration.zero);
    propagate(keyEvent);
  }
}

void main() {
  test("Capture and transmit the delete event from keyboard", () {
    final mockDeletion = MockDeletionTester();
    final propagator = KeyEventPropagator(
        child: KeyboardController(figureDeletion: mockDeletion));
    propagator.emitKeyDownDelete();
    verify(() => mockDeletion.delete()).called(1);
  });
}
