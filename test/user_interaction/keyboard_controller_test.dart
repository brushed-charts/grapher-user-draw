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

  void emitKeyDownBackspace() {
    const keyEvent = KeyDownEvent(
        physicalKey: PhysicalKeyboardKey.backspace,
        logicalKey: LogicalKeyboardKey.backspace,
        timeStamp: Duration.zero);
    propagate(keyEvent);
  }

  void emitKeyDownLetter() {
    const keyEvent = KeyDownEvent(
        physicalKey: PhysicalKeyboardKey.keyA,
        logicalKey: LogicalKeyboardKey.keyA,
        timeStamp: Duration.zero);
    propagate(keyEvent);
  }

  void emitKeyDownCapsLock() {
    const keyEvent = KeyDownEvent(
        physicalKey: PhysicalKeyboardKey.capsLock,
        logicalKey: LogicalKeyboardKey.capsLock,
        timeStamp: Duration.zero);
    propagate(keyEvent);
  }
}

void main() {
  late MockUserInteraction mockEdition;
  late MockInteractionReference interactionRefence;
  late KeyEventPropagator propagator;

  setUp(() {
    mockEdition = MockUserInteraction();
    interactionRefence = MockInteractionReference();
    when(() => interactionRefence.deleteInterface).thenReturn(mockEdition);
    propagator = KeyEventPropagator(
        child: KeyboardController(interactionReference: interactionRefence));
  });

  group("Check deletion from keyboard", () {
    test("Expect on delete key the deletion event will be propagated", () {
      propagator.emitKeyDownDelete();
      verify(() => mockEdition.delete()).called(1);
    });

    test("Expect on backspace key the deletion event will be propagated", () {
      propagator.emitKeyDownBackspace();
      verify(() => mockEdition.delete()).called(1);
    });
  });

  test(
      "Check that other keys except delete and backspace "
      "don't propgagate the deletion event", () {
    propagator.emitKeyDownCapsLock();
    propagator.emitKeyDownLetter();
    verifyNever(() => mockEdition.delete());
  });
}
