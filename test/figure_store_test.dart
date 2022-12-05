import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/anchor.dart';
import 'package:grapher_user_draw/figure.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:mocktail/mocktail.dart';

class MockFigure extends Mock implements Figure {
  @override
  final int groupID;
  MockFigure({required this.groupID});
}

void main() {
  test('Test figures can be added to the store and retrieved by ID', () {
    final store = FigureStore();
    final expectedFigure = Figure(1);
    store.upsert(expectedFigure);
    final retrievedFigure = store.getByID(expectedFigure.groupID);
    expect(retrievedFigure, equals(expectedFigure));
  });

  test('Test retrieving all Figure from the store', () {
    final store = FigureStore();
    final figureList = generateFigures(5);
    addFiguresToStore(store, figureList);
    expect(store.getAll(), equals(figureList));
  });

  test('Test Figure store length function return the right result', () {
    const expectedLength = 5;
    final store = FigureStore();
    final figureList = generateFigures(5);
    addFiguresToStore(store, figureList);
    expect(store.length, equals(expectedLength));
  });

  test('Retriving anchors by datetime', () {
    registerFallbackValue(DateTime.now());
    final searchDate = DateTime(2022, 12, 04, 01);
    final wrongDate = DateTime(2022, 10, 04, 01);
    final anchorA = Anchor(x: searchDate, y: 2356);
    final anchorC = Anchor(x: searchDate, y: 2356);
    final anchorB = Anchor(x: wrongDate, y: 906);

    final figures = generateFigures(4);
    figures[0].add(anchorA);
    figures[1].add(anchorB);
    figures[2].add(anchorC);

    final store = FigureStore();
    addFiguresToStore(store, figures);

    expect(store.getByDatetime(searchDate), equals([anchorA, anchorC]));
  });

  group("Inside FigureStore using an anchor reference assert", () {
    test("figure can be retrieved when it contains the reference", () {
      final store = FigureStore();
      final figurePopulation = generateFigures(3);
      final refAnchor = Anchor(x: DateTime(2022, 12, 05), y: 1.3245);
      final expectedFigure = figurePopulation[1];
      figurePopulation[1].add(refAnchor);
      addFiguresToStore(store, figurePopulation);
      final retrievedFigure = store.getByAnchor(refAnchor);

      expect(retrievedFigure, equals(expectedFigure));
    });
    test("resulting figure is null when their is no matching anchor", () {
      final store = FigureStore();
      final figurePopulation = generateFigures(3);
      final refAnchor = Anchor(x: DateTime(2022, 12, 05), y: 1.3245);
      addFiguresToStore(store, figurePopulation);
      final retrievedFigure = store.getByAnchor(refAnchor);

      expect(retrievedFigure, isNull);
    });
    test(
        "only the first matching figure is output when "
        "the reference appear in many figures", () {
      final store = FigureStore();
      final figurePopulation = generateFigures(3);
      final refAnchor = Anchor(x: DateTime(2022, 12, 05), y: 1.3245);
      final expectedFigure = figurePopulation[0];
      figurePopulation[0].add(refAnchor);
      figurePopulation[2].add(refAnchor);
      addFiguresToStore(store, figurePopulation);
      final retrievedFigure = store.getByAnchor(refAnchor);

      expect(retrievedFigure, equals(expectedFigure));
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
    figList.add(Figure(aRandomPickedCount));
  }
  return figList;
}
