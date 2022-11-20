import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher_user_draw/draw_tool_interface.dart';
import 'package:grapher_user_draw/figure.dart';
import 'package:grapher_user_draw/presenter.dart';
import 'package:mocktail/mocktail.dart';

class MockDrawTool extends Mock implements DrawToolInterface {}

class MockFigure extends Mock implements Figure {}

class MockCanvas extends Mock implements Canvas {}

void main() {
  final Canvas mockCanvas = MockCanvas();
  final DrawZone drawZone = DrawZone(Offset.zero, const Size(500, 500));
  final DrawEvent drawEvent = DrawEvent(mockCanvas, drawZone);
  final Figure mockFigure = MockFigure();
  late DrawToolInterface mockTool;
  late DrawPresenter presenter;
  late Function() toolDraw;
  registerFallbackValue(Figure(1));
  registerFallbackValue(drawEvent);

  setUp(() {
    mockTool = MockDrawTool();
    presenter = DrawPresenter(tool: mockTool);
    toolDraw = () => mockTool.draw(captureAny(), captureAny());
  });

  group('Assert tool draw function', () {
    test("is not called when presenter didn't received DrawEvent", () {
      presenter.draw(mockFigure);
      verifyNever(toolDraw);
    });
    test('is called when DrawEvent was prior received ', () {
      presenter.onDrawEvent(drawEvent);
      presenter.draw(mockFigure);
      final capturedParams = verify(toolDraw).captured;
      expect(capturedParams[0], equals(drawEvent));
      expect(capturedParams[1], equals(mockFigure));
    });
  });
}
