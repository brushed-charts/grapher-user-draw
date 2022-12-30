import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/anchor.dart';
import 'package:grapher_user_draw/draw_tools/draw_tool_interface.dart';
import 'package:grapher_user_draw/figure.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:mocktail/mocktail.dart';

class MockFigure extends Mock implements Figure {
  @override
  final int groupID;
  MockFigure({required this.groupID});
}

class MockDrawTool extends Mock implements DrawToolInterface {
  @override
  final String name = "test tool";
  @override
  final int maxLength;
  MockDrawTool(this.maxLength);
}

void main() {
  late FigureStore store;
  late List<Figure> figurePopulation;

  setUp(() {
    store = FigureStore();
    figurePopulation = generateFigures(4);
  });

  test('Test figures can be added to the store and retrieved by ID', () {
    final expectedFigure = Figure(MockDrawTool(1));
    store.upsert(expectedFigure);
    final retrievedFigure = store.getByID(expectedFigure.groupID);
    expect(retrievedFigure, equals(expectedFigure));
  });

  test('Test retrieving all Figure from the store', () {
    addFiguresToStore(store, figurePopulation);
    expect(store.getAll(), equals(figurePopulation));
  });

  test('Test Figure store length function return the right result', () {
    const expectedLength = 4;
    addFiguresToStore(store, figurePopulation);
    expect(store.length, equals(expectedLength));
  });

  test('Retriving anchors by datetime', () {
    registerFallbackValue(DateTime.now());
    final searchDate = DateTime(2022, 12, 04, 01);
    final wrongDate = DateTime(2022, 10, 04, 01);
    final anchorA = Anchor(x: searchDate, y: 2356);
    final anchorC = Anchor(x: searchDate, y: 2356);
    final anchorB = Anchor(x: wrongDate, y: 906);

    figurePopulation[0].add(anchorA);
    figurePopulation[1].add(anchorB);
    figurePopulation[2].add(anchorC);
    addFiguresToStore(store, figurePopulation);

    expect(store.getByDatetime(searchDate), equals([anchorA, anchorC]));
  });

  group("Inside FigureStore using an anchor reference assert", () {
    final anchorReference = Anchor(x: DateTime(2022, 12, 05), y: 1.3245);
    test("figure can be retrieved when it contains the reference", () {
      final expectedFigure = figurePopulation[1];
      figurePopulation[1].add(anchorReference);
      addFiguresToStore(store, figurePopulation);
      final retrievedFigure = store.getByAnchor(anchorReference);

      expect(retrievedFigure, equals(expectedFigure));
    });
    test("resulting figure is null when their is no matching anchor", () {
      addFiguresToStore(store, figurePopulation);
      final retrievedFigure = store.getByAnchor(anchorReference);

      expect(retrievedFigure, isNull);
    });
    test(
        "only the first matching figure is output when "
        "the reference appear in many figures", () {
      final expectedFigure = figurePopulation[0];
      figurePopulation[0].add(anchorReference);
      figurePopulation[2].add(anchorReference);
      addFiguresToStore(store, figurePopulation);
      final retrievedFigure = store.getByAnchor(anchorReference);

      expect(retrievedFigure, equals(expectedFigure));
    });
  });

  group("Inside FigureStore, on deletion", () {
    test("assert the expected figure is removed when groupID is found", () {
      final idToRemove = figurePopulation[2].groupID;
      addFiguresToStore(store, figurePopulation);
      store.delete(idToRemove);
      expect(store.getByID(idToRemove), isNull);
      expect(store.length, figurePopulation.length - 1);
    });
    test("assert no figure is deleted if groupID was not found", () {
      const randomID = 0;
      addFiguresToStore(store, figurePopulation);
      store.delete(randomID);
      expect(store.getByID(randomID), isNull);
      expect(store.length, figurePopulation.length);
    });
  });

  group("Expect figure store populate function", () {
    test("to remove old content", () {
      final startFigure = Figure(MockDrawTool(20));
      store.upsert(startFigure);
      expect(store.getAll().contains(startFigure), isTrue);
      store.populate(figurePopulation);
      expect(store.getAll().contains(startFigure), isFalse);
    });
    test("to fill the store with the given figures", () {
      store.populate(figurePopulation);
      expect(store.getAll(), equals(figurePopulation));
    });
  });
}

void addFiguresToStore(FigureStore store, List<Figure> figureList) {
  for (final figure in figureList) {
    store.upsert(figure);
  }
}

List<Figure> generateFigures(int count) {
  const aRandomPickedCount = 3;
  final figList = <Figure>[];
  for (int i = 0; i < count; i++) {
    figList.add(Figure(MockDrawTool(aRandomPickedCount)));
  }
  return figList;
}
