import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher_user_draw/user_interaction/figure_deletion_interface.dart';
import 'package:grapher_user_draw/user_interaction/keyboard_controller.dart';
import 'package:grapher_user_draw/user_interaction/interaction_reference.dart';
import 'package:mocktail/mocktail.dart';

import 'gesture_interpreter_test.dart';

class MockDeletionTester extends Mock implements FigureDeletionInterface {}

class MockInteractionReference extends Mock implements InteractionReference {}

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
    final mockEdition = MockUserInteraction();
    final interactionRefence = MockInteractionReference();
    when(() => interactionRefence.deleteInterface).thenReturn(mockEdition);
    final propagator = KeyEventPropagator(
        child: KeyboardController(interactionReference: interactionRefence));
    propagator.emitKeyDownDelete();
    verify(() => mockEdition.delete()).called(1);
  });
}
