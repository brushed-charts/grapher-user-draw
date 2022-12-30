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
import 'package:grapher_user_draw/presenter.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:mocktail/mocktail.dart';

class MockFigure extends Mock implements Figure {
  @override
  final DrawToolInterface tool;
  MockFigure(this.tool);
}

class MockCanvas extends Mock implements Canvas {}

class MockUnitAxis extends Mock implements UnitAxis {}

class MockVirtualAxis extends Mock implements VirtualAxis {}

class MockDrawInfo extends Mock implements DrawInfo {}

class MockStore extends Mock implements FigureStore {}

class MockDrawTool extends Mock implements DrawToolInterface {
  @override
  final String name = "test tool";
  @override
  final int maxLength;
  MockDrawTool(this.maxLength);
}

void main() {
  final Canvas mockCanvas = MockCanvas();
  final DrawZone drawZone = DrawZone(Offset.zero, const Size(500, 500));
  final DrawEvent drawEvent = DrawEvent(mockCanvas, drawZone);
  final mockStore = MockStore();
  final ViewEvent viewEvent = ViewEvent(
    drawEvent,
    MockUnitAxis(),
    MockVirtualAxis(),
    <Data2D?>[],
  );
  late Figure mockFigureA;
  late Figure mockFigureB;
  late DrawToolInterface mockTool;
  late DrawPresenter presenter;
  late Function() toolDraw;

  when(() => mockStore.length).thenReturn(3);
  registerFallbackValue(Figure(MockDrawTool(1)));
  registerFallbackValue(DrawInfo(viewEvent));

  setUp(() {
    mockTool = MockDrawTool(1);
    presenter = DrawPresenter(mockStore);
    toolDraw = () => mockTool.draw(captureAny(), captureAny());
    mockFigureA = MockFigure(mockTool);
    mockFigureB = MockFigure(mockTool);
  });

  test("Assert tool's draw function is called on presenter draw", () {
    when(() => mockStore.getAll()).thenReturn([mockFigureA, mockFigureB]);
    presenter.draw(viewEvent);

    final toolDrawCallResult = verify(toolDraw);
    final capturedParams = toolDrawCallResult.captured;
    final captureDrawInfo = capturedParams[0] as DrawInfo;

    toolDrawCallResult.called(2);
    expect(captureDrawInfo.canvas, equals(mockCanvas));
    expect(captureDrawInfo.event, equals(viewEvent));
    expect(capturedParams[1], equals(mockFigureA));
  });
}
