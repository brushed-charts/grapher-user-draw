import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher_user_draw/draw_tools/draw_tool_event.dart';
import 'package:grapher_user_draw/draw_tools/draw_tool_interface.dart';
import 'package:grapher_user_draw/user_interaction/interaction_reference.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/interaction_controller.dart';
import 'package:mocktail/mocktail.dart';

import 'gesture_controller_test.dart';

class MockDrawTool extends Mock implements DrawToolInterface {}

class MockToolPropagator extends GraphObject with SinglePropagator {
  MockToolPropagator({required GraphObject child}) {
    this.child = child;
  }
  void propagateToolEvent(DrawToolEvent event) {
    propagate(event);
  }
}

void main() {
  const figureMaxLength = 2;
  final mockTool = MockDrawTool();
  final event = DrawToolEvent(mockTool);
  final interactionRef = InteractionReference(
      FigureStore(), MockAnchorSelectionCondition(), MockReferenceReader());
  final interactionController = InteractionController(interactionRef);
  final mockPropagator = MockToolPropagator(child: interactionController);
  when(() => mockTool.maxLength).thenReturn(figureMaxLength);

  test('Expect interaction controller to update interaction reference', () {
    mockPropagator.propagateToolEvent(event);
    expect(interactionRef.tool, equals(mockTool));
  });
}
