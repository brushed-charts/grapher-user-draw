import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/core/interaction_rules.dart';
import 'package:grapher_user_draw/logic/anchor_operation.dart';
import 'package:grapher_user_draw/logic/edition_interaction.dart';
import 'package:grapher_user_draw/logic/virtual_coord.dart';
import 'package:mocktail/mocktail.dart';

import '../misc/generator.dart';

class MockAnchorOperation extends Mock implements AnchorOperation {}

class MockInteractionRules extends Mock implements InteractionRules {}

void main() {
  testEditionInteractionTap();
  testEditionInteractionDrag();
}

void testEditionInteractionTap() {
  group("Test tap EditionInteraction when:", () {
    final tapX = DateTime(2022, 11, 08, 00, 32);
    final tapCoord = VirtualCoord(x: tapX, y: 1234);
    final mockOperation = MockAnchorOperation();
    final interaction = EditionInteraction(mockOperation);
    final anyAnchor = generateAnchor(tapX);
    test("an anchor is selected", () {
      when(() => mockOperation.anchorSelected(tapCoord)).thenReturn(anyAnchor);
      interaction.handleTap(tapCoord);
      verify(() => mockOperation.anchorSelected(tapCoord)).called(1);
    });
    test("no anchor is touched", () {
      when(() => mockOperation.anchorSelected(tapCoord)).thenReturn(null);
      interaction.handleTap(tapCoord);
      verify(() => mockOperation.anchorSelected(tapCoord)).called(1);
      expect(interaction.selection, isNull);
    });
  });
}

void testEditionInteractionDrag() {
  group("Test drag EditionInteraction", () {
    final startDragX = DateTime(2022, 11, 09, 00, 25);
    const double startDragY = 12345;
    final startDragCoord = VirtualCoord(x: startDragX, y: startDragY);
    final mockOperation = MockAnchorOperation();
    final interaction = EditionInteraction(mockOperation);
    final anyAnchor = generateAnchor(startDragX);
    test("either dragStart update the selected anchor", () {
      when(() => mockOperation.anchorSelected(startDragCoord))
          .thenReturn(anyAnchor);
      interaction.handleDragStart(startDragCoord);
      expect(interaction.selection, equals(anyAnchor));
    });
    test("either dragStart set selection to null when pointing on nothing", () {
      when(() => mockOperation.anchorSelected(startDragCoord))
          .thenReturn(anyAnchor);
      interaction.handleDragStart(startDragCoord);
      expect(interaction.selection, equals(anyAnchor));
    });
    test("either dragEnd set selection to null", () {
      interaction.handleDragEnd(startDragCoord);
      expect(interaction.selection, isNull);
    });
    test('either drag really move the anchor', () {
      final newDragX = DateTime(2022, 11, 09, 00, 30);
      const double newDragY = 1109;
      final newDragCoord = VirtualCoord(x: newDragX, y: newDragY);
      final interaction = EditionInteraction(AnchorOperation());
      interaction.selection = anyAnchor;
      interaction.handleDrag(newDragCoord);
      expect(anyAnchor.x, newDragX);
      expect(anyAnchor.y, newDragY);
    });
  });
}
