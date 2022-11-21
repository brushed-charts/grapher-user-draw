import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/view/axis/unit-axis.dart';
import 'package:grapher/view/axis/virtual-axis.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher_user_draw/draw_tools/draw_info.dart';
import 'package:grapher_user_draw/draw_tools/draw_tool_interface.dart';
import 'package:grapher_user_draw/figure.dart';
import 'package:grapher_user_draw/draw_presenter.dart';
import 'package:mocktail/mocktail.dart';

class MockDrawTool extends Mock implements DrawToolInterface {}

class MockFigure extends Mock implements Figure {}

class MockCanvas extends Mock implements Canvas {}

class MockUnitAxis extends Mock implements UnitAxis {}

class MockVirtualAxis extends Mock implements VirtualAxis {}

class MockDrawInfo extends Mock implements DrawInfo {}

void main() {
  final Canvas mockCanvas = MockCanvas();
  final DrawZone drawZone = DrawZone(Offset.zero, const Size(500, 500));
  final DrawEvent drawEvent = DrawEvent(mockCanvas, drawZone);
  final ViewEvent viewEvent = ViewEvent(
    drawEvent,
    MockUnitAxis(),
    MockVirtualAxis(),
    <Data2D?>[],
  );
  final Figure mockFigure = MockFigure();
  late DrawToolInterface mockTool;
  late DrawPresenter presenter;
  late Function() toolDraw;
  registerFallbackValue(Figure(1));
  registerFallbackValue(DrawInfo(viewEvent));

  setUp(() {
    mockTool = MockDrawTool();
    presenter = DrawPresenter(tool: mockTool);
    toolDraw = () => mockTool.draw(captureAny(), captureAny());
  });

  test("Assert tool's draw function is called on presenter draw", () {
    presenter.draw(viewEvent, mockFigure);
    final capturedParams = verify(toolDraw).captured;
    final captureDrawInfo = capturedParams[0] as DrawInfo;
    expect(captureDrawInfo.canvas, equals(mockCanvas));
    expect(captureDrawInfo.event, equals(viewEvent));
    expect(capturedParams[1], equals(mockFigure));
  });
}
