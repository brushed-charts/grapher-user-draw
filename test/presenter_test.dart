import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/axis/unit-axis.dart';
import 'package:grapher/view/axis/virtual-axis.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher_user_draw/draw_tools/draw_info.dart';
import 'package:grapher_user_draw/draw_tools/draw_tool_event.dart';
import 'package:grapher_user_draw/draw_tools/draw_tool_interface.dart';
import 'package:grapher_user_draw/figure.dart';
import 'package:grapher_user_draw/presenter.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:mocktail/mocktail.dart';

class MockDrawTool extends Mock implements DrawToolInterface {}

class MockFigure extends Mock implements Figure {}

class MockCanvas extends Mock implements Canvas {}

class MockUnitAxis extends Mock implements UnitAxis {}

class MockVirtualAxis extends Mock implements VirtualAxis {}

class MockDrawInfo extends Mock implements DrawInfo {}

class MockStore extends Mock implements FigureStore {}

class MockPropagator extends GraphObject with SinglePropagator {
  MockPropagator(GraphObject child) {
    this.child = child;
  }

  void propagateToolEvent(DrawToolEvent event) {
    propagate(event);
  }
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
  final Figure mockFigure = MockFigure();
  late DrawToolInterface mockTool;
  late DrawPresenter presenter;
  late Function() toolDraw;

  when(() => mockStore.length).thenReturn(3);
  registerFallbackValue(Figure(1));
  registerFallbackValue(DrawInfo(viewEvent));

  setUp(() {
    mockTool = MockDrawTool();
    presenter = DrawPresenter(mockStore);
    toolDraw = () => mockTool.draw(captureAny(), captureAny());
  });

  test("Assert tool's draw function is called on presenter draw", () {
    MockPropagator(presenter).propagate(DrawToolEvent(mockTool));
    when(() => mockStore.getAll()).thenReturn([mockFigure, MockFigure()]);
    presenter.draw(viewEvent);

    final toolDrawCallResult = verify(toolDraw);
    final capturedParams = toolDrawCallResult.captured;
    final captureDrawInfo = capturedParams[0] as DrawInfo;

    toolDrawCallResult.called(2);
    expect(captureDrawInfo.canvas, equals(mockCanvas));
    expect(captureDrawInfo.event, equals(viewEvent));
    expect(capturedParams[1], equals(mockFigure));
  });
}
