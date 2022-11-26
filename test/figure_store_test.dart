import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/figure.dart';
import 'package:grapher_user_draw/store.dart';

void main() {
  test('Test figures can be added to the store and retrieved by ID', () {
    final store = FigureStore();
    final expectedFigure = Figure(1);
    store.upsert(expectedFigure);
    final retrievedFigure = store.getByID(expectedFigure.groupID);
    expect(retrievedFigure, equals(expectedFigure));
  });

  test('Retrieving all Figure from the store', () {
    final store = FigureStore();
    final figureList = generateFigures(5);
    addFiguresToStore(store, figureList);
    expect(store.getAll(), equals(figureList));
  });
}

void addFiguresToStore(FigureStore store, List<Figure> figureList) {
  for (final figure in figureList) {
    store.upsert(figure);
  }
}

List<Figure> generateFigures(int count) {
  final figList = <Figure>[];
  for (int i = 0; i < count; i++) {
    figList.add(Figure(3));
  }
  return figList;
}
