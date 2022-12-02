import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/draw_tools/draw_tool_interface.dart';
import 'package:grapher_user_draw/user_interaction/interaction_reference.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/creation_interaction.dart';
import 'package:grapher_user_draw/user_interaction/edition_interaction.dart';
import 'package:mocktail/mocktail.dart';

class MockFigureStore extends Mock implements FigureStore {}

class MockDrawTool extends Mock implements DrawToolInterface {}

void main() {
  const figureMaxLength = 4;
  late InteractionReference interactionRef;
  final mockTool = MockDrawTool();
  when(() => mockTool.maxLength).thenReturn(figureMaxLength);

  setUp(() {
    interactionRef = InteractionReference(MockFigureStore());
  });

  test(
      "Assert interaction reference switch to creation"
      "when non null tool is received", () {
    interactionRef.tool = mockTool;
    expect(interactionRef.tool, equals(mockTool));
    expect(interactionRef.interface, isInstanceOf<CreationInteraction>());
    expect((interactionRef.interface as CreationInteraction).figureLength,
        figureMaxLength);
  });

  test(
      "Assert interaction reference switch to edition"
      "when tool received is null", () {
    interactionRef.tool = null;
    expect(interactionRef.interface, isInstanceOf<EditionInteraction>());
    expect(interactionRef.tool, isNull);
  });
}
