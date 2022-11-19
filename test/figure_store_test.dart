import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/figure.dart';
import 'package:grapher_user_draw/store.dart';

void main() {
  test('Test figures can be added to the store and retrieved by ID', () {
    final store = FigureStore();
    final expectedFigure = Figure(1);
    store.add(expectedFigure);
    final retrievedFigure = store.getByID(expectedFigure.groupID);
    expect(retrievedFigure, equals(expectedFigure));
  });
}
