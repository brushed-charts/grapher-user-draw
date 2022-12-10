import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/anchor.dart';
import 'package:grapher_user_draw/draw_tools/draw_tool_interface.dart';
import 'package:grapher_user_draw/figure.dart';
import 'package:grapher_user_draw/figure_database_interface.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/creation_interaction.dart';
import 'package:grapher_user_draw/virtual_coord.dart';
import 'package:mocktail/mocktail.dart';

class MockFigureDatabase extends Mock implements FigureDatabaseInterface {}

class MockFigureStore extends Mock implements FigureStore {}

class MockDrawTool extends Mock implements DrawToolInterface {
  @override
  final int maxLength;
  MockDrawTool(this.maxLength);
}

void main() {
  registerFallbackValue(Figure(MockDrawTool(1)));
  final tapPosA = VirtualCoord(DateTime(2022, 11, 19), 1052);
  final tapPosB = VirtualCoord(DateTime(2022, 11, 18), 2052);
  final anchorA = Anchor(x: tapPosA.x, y: tapPosA.y);
  final anchorB = Anchor(x: tapPosB.x, y: tapPosB.y);
  final mockDrawTool = MockDrawTool(2);
  late FigureDatabaseInterface mockDatabase;
  late FigureStore mockStore;
  late CreationInteraction userInteraction;
  late Function() storeAdd;

  setUp(() {
    mockStore = MockFigureStore();
    mockDatabase = MockFigureDatabase();
    userInteraction =
        CreationInteraction(mockDrawTool, mockStore, mockDatabase);
    storeAdd = () => mockStore.upsert(captureAny());
    when(mockStore.getAll).thenReturn([]);
  });

  group('Assert many tap add anchor', () {
    test('in the same figure when it is not full', () {
      simulateTap(userInteraction, [tapPosA, tapPosB]);
      final paramList = verify(storeAdd).captured.cast<Figure>();
      expect(paramList[1].contains(anchorA), isTrue);
      expect(paramList[1].contains(anchorB), isTrue);
      expect(paramList[0].groupID, equals(paramList[1].groupID));
    });

    test('in different figure when it is full', () {
      simulateTap(userInteraction, [tapPosA, tapPosB, tapPosB]);
      final paramList = verify(storeAdd).captured.cast<Figure>();
      final figure1 = paramList[0];
      final figure2 = paramList[2];
      expect(figure1.groupID, isNot(equals(figure2.groupID)));
    });
  });

  test("Expect on creation,saving occurs when figure is completed", () {
    simulateTap(userInteraction, [tapPosA, tapPosB]);
    verify(() => mockDatabase.save(any(), any())).called(1);
  });
}

void simulateTap(CreationInteraction interaction, List<VirtualCoord> taps) {
  for (final tap in taps) {
    interaction.onTap(tap);
  }
}
