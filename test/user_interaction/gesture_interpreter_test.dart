import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/reference/reader.dart';
import 'package:grapher_user_draw/figure_database_interface.dart';
import 'package:grapher_user_draw/user_interaction/bypass_pointer_event.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/user_interaction/gesture_interpreter.dart';
import 'package:grapher_user_draw/user_interaction/pointer_convertion_logic.dart';
import 'package:grapher_user_draw/user_interaction/anchor_selection_condition.dart';
import 'package:grapher_user_draw/user_interaction/edition_interaction.dart';
import 'package:grapher_user_draw/user_interaction/interaction_reference.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/virtual_coord.dart';
import 'package:mocktail/mocktail.dart';

class MockUserInteraction extends Mock implements EditionInteraction {}

class MockPointerConverterLogic extends Mock
    implements PointerConvertionLogic {}

class MockCoordTranslator extends Mock implements CoordTranslater {}

class MockPointerEventBypassChild extends Mock
    implements PointerEventBypassChild {}

class MockReferenceReader<PointerEventBypassChild extends GraphObject>
    extends Mock implements ReferenceReader<MockPointerEventBypassChild> {
  @override
  MockPointerEventBypassChild? read() {
    return MockPointerEventBypassChild();
  }
}

class MockAnchorSelectionCondition extends Mock
    implements AnchorYSelectionCondition {}

class MockFigureDatabase extends Mock implements FigureDatabaseInterface {}

void main() {
  TestGestureInterpreter().testInterpretationOfTap();
  TestGestureInterpreter().testThereIsNoCallWhenVCoordIsNull();
  TestGestureInterpreter().assertDragStartIsCalledBeforeDrag();
}

class TestGestureInterpreter {
  late final GestureInterpreter _interpreter;
  late final InteractionReference _interactionRef;
  final _store = FigureStore();
  final outputVCoord = VirtualCoord(DateTime(2022, 11, 17, 15), 1495);
  late final MockPointerConverterLogic _mockConverterLogic;

  TestGestureInterpreter() {
    registerFallBacks();
    initMocks();
    _interactionRef = InteractionReference(
        _store,
        MockAnchorSelectionCondition(),
        MockReferenceReader(),
        MockFigureDatabase());
    _interactionRef.tapInterface = MockUserInteraction();
    _interactionRef.dragInterface = MockUserInteraction();
    _interpreter = GestureInterpreter(
        refGraphDragBlocker: MockReferenceReader(),
        interactionReference: _interactionRef,
        zoneConverter: _mockConverterLogic);

    mockConvertionToVirtual() => _mockConverterLogic.toVirtual(any());
    when(() => mockConvertionToVirtual()).thenReturn(outputVCoord);
  }

  void registerFallBacks() {
    registerFallbackValue(VirtualCoord.zero());
    registerFallbackValue(Offset.zero);
  }

  void initMocks() {
    _mockConverterLogic = MockPointerConverterLogic();
  }

  void testInterpretationOfTap() {
    test('Assert cycle tap down/up without drag is interpreted as Tap', () {
      simulateTapCycle();
      verify(() => _interactionRef.tapInterface.onTap(any())).called(1);
    });

    test('Assert Tap() is called with the right VirtualCoord', () {
      simulateTapCycle();
      void expressionToTest() =>
          _interactionRef.tapInterface.onTap(captureAny());
      final parameterList = verify(() => expressionToTest()).captured;
      final param = parameterList[0];
      expect(param, equals(outputVCoord));
    });
  }

  void testThereIsNoCallWhenVCoordIsNull() {
    group('When translation from pixel to virtual is null', () {
      test('assert Tap is not called', () {
        when(() => _mockConverterLogic.toVirtual(any())).thenReturn(null);
        simulateTapCycle();
        verifyNever(() => _interactionRef.tapInterface.onTap(any()));
      });

      test('assert Drag is not called', () {
        when(() => _mockConverterLogic.toVirtual(any())).thenReturn(null);
        simulateDrag();
        verifyNever(() => _interactionRef.dragInterface!.onDrag(any()));
      });
    });
  }

  void assertDragStartIsCalledBeforeDrag() {
    test(
        "Check whether interaction DragStart()"
        "is called one time per drag cycle (start/update/end)", () {
      simulateDrag();
      simulateDrag();
      dragStartFunction() =>
          _interactionRef.dragInterface!.onDragStart(captureAny());
      final callResult = verify(dragStartFunction);
      callResult.called(2);
      expect(callResult.captured[0], isInstanceOf<VirtualCoord>());
    });
  }

  void simulateTapCycle() {
    _interpreter.onTapUp(TapUpDetails(kind: PointerDeviceKind.unknown));
  }

  void simulateDrag([int dragCount = 10]) {
    for (double i = 0; i < dragCount; i++) {
      _interpreter.onDrag(DragUpdateDetails(globalPosition: Offset(i, i)));
    }
    _interpreter.onDragEnd(DragEndDetails());
  }
}
