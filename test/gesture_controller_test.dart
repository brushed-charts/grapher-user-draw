import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/gesture_controller.dart';
import 'package:grapher_user_draw/user_interaction.dart';
import 'package:grapher_user_draw/virtual_coord.dart';
import 'package:mocktail/mocktail.dart';

class MockUserInteraction extends Mock implements UserInteraction {}

class MockCoordTranslator extends Mock implements CoordTranslater {}

void main() {
  TestGestureController().testInterpretationOfTap();
  TestGestureController().testDragInterpreter();
  TestGestureController().testThereIsNoCallWhenVCoordIsNull();
  TestGestureController().expectPointerOutOfDrawZoneIsIgnored();
}

class TestGestureController {
  late final GestureController _controller;
  late final UserInteraction _userInteraction;
  late final CoordTranslater _coordTranslator;
  final outputVCoord = VirtualCoord(DateTime(2022, 11, 17, 15), 1495);
  final _safeDrawZone = DrawZone(const Offset(0, 0), const Size(10000, 10000));

  TestGestureController() {
    registerFallBacks();
    initMocks();
    _controller = GestureController(
      interactor: _userInteraction,
      translator: _coordTranslator,
    );
    _controller.drawZone = _safeDrawZone;

    mockTranslationToVirtual() => _coordTranslator.toVirtual(any());
    when(() => mockTranslationToVirtual()).thenReturn(outputVCoord);
  }

  void registerFallBacks() {
    registerFallbackValue(VirtualCoord.zero());
    registerFallbackValue(Offset.zero);
  }

  void initMocks() {
    _coordTranslator = MockCoordTranslator();
    _userInteraction = MockUserInteraction();
  }

  void testInterpretationOfTap() {
    test('Assert cycle tap down/up without drag is interpreted as Tap', () {
      simulateTapCycle();
      verify(() => _userInteraction.onTap(any())).called(1);
    });

    test('Assert Tap() is called with the right VirtualCoord', () {
      simulateTapCycle();
      void expressionToTest() => _userInteraction.onTap(captureAny());
      final parameterList = verify(() => expressionToTest()).captured;
      final param = parameterList[0];
      expect(param, equals(outputVCoord));
    });
  }

  void testThereIsNoCallWhenVCoordIsNull() {
    group('When translation from pixel to virtual is null', () {
      test('assert Tap is not called', () {
        when(() => _coordTranslator.toVirtual(any())).thenReturn(null);
        simulateTapCycle();
        verifyNever(() => _userInteraction.onTap(any()));
      });

      test('assert Drag is not called', () {
        when(() => _coordTranslator.toVirtual(any())).thenReturn(null);
        simulateDrag();
        verifyNever(() => _userInteraction.onDrag(any()));
      });
    });
  }

  void testDragInterpreter() {
    group('When a drag occure during a tap down/up cycle', () {
      const dragCount = 20;
      simulateDrag(dragCount);

      test('assert that Tap() is not called', () {
        verifyNever(() => _userInteraction.onTap(any()));
      });

      test('assert that Drag() is called multiple times', () {
        verify(() => _userInteraction.onDrag(any())).called(dragCount);
      });
    });
  }

  void expectPointerOutOfDrawZoneIsIgnored() {
    group('When pointer is out of the DrawZone', () {
      const tapPos = Offset(100, 10);
      final drawZone = DrawZone(const Offset(0, 500), const Size(1000, 500));
      _controller.drawZone = drawZone;
      test('Expect UserInteraction\'s Tap is ignored', () {
        _controller.onTapDown(TapDownDetails(localPosition: tapPos));
        _controller.onTapUp(TapUpDetails(
          kind: PointerDeviceKind.unknown,
          localPosition: tapPos,
        ));
        verifyNever(() => _userInteraction.onTap(any()));
      });
      test('Expect UserInteraction\'s Drag is ignored', () {
        _controller.onTapDown(TapDownDetails(localPosition: tapPos));
        _controller.onTapUp(TapUpDetails(
          kind: PointerDeviceKind.unknown,
          localPosition: tapPos,
        ));
        verifyNever(() => _userInteraction.onTap(any()));
      });
    });
  }

  void simulateTapCycle() {
    _controller.onTapDown(TapDownDetails());
    _controller.onTapUp(TapUpDetails(kind: PointerDeviceKind.unknown));
  }

  void simulateDrag([int dragCount = 10]) {
    _controller.onTapDown(TapDownDetails());
    for (double i = 0; i < dragCount; i++) {
      _controller.onDrag(DragUpdateDetails(globalPosition: Offset(i, i)));
    }
    _controller.onTapUp(TapUpDetails(kind: PointerDeviceKind.unknown));
  }
}
