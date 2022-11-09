import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/core/anchor_2d.dart';
import 'package:grapher_user_draw/logic/figure.dart';
import 'package:grapher_user_draw/logic/figure_store.dart';
import 'package:grapher_user_draw/logic/virtual_coord.dart';
import 'package:mocktail/mocktail.dart';

import '../misc/generator.dart';

class MockFigure extends Mock implements Figure {}

void main() {
  testStoreGetAnchorByCoord();
  testAddingFigure();
}

void testStoreGetAnchorByCoord() {
  group("Test FigureStore: getAnchorByCoord() when:", () {
    test("tapCoord is pointing to an anchor", () {
      final store = FigureStore();
      final tapCoord = VirtualCoord(x: DateTime(2022, 11, 07, 00, 35), y: 23.0);
      final knownFigure = generateFigure(5, 5);
      final knownAnchor = Anchor2D(12345, DateTime(2022, 11, 07, 00, 35), 23);
      knownFigure.anchorList[3] = knownAnchor;
      store.add(MockFigure());
      store.add(knownFigure);
      store.add(MockFigure());
      final hitAnchor = store.getAnchorByCoord(tapCoord);
      expect(hitAnchor, equals(knownAnchor));
    });

    test(
        "tapCoord is not pointing to an anchor (non mocking to validate with <T> = Anchor but input is Anchor2D)",
        () {
      final store = FigureStore();
      final tapCoord = VirtualCoord(x: DateTime(2022, 11, 07, 00, 35), y: 23.0);
      final knownFigure = generateFigure(5, 5);
      final knownAnchor = Anchor2D(12345, DateTime(2022, 11, 07, 00, 35), 100);
      knownFigure.anchorList[3] = knownAnchor;
      store.add(MockFigure());
      store.add(knownFigure);
      store.add(MockFigure());
      final hitAnchor = store.getAnchorByCoord(tapCoord);
      expect(hitAnchor, isNull);
    });

    test('taCoord is pointing to nothing (mocking)', () {
      final store = FigureStore();
      final tapCoord = VirtualCoord(x: DateTime(2022, 11, 07, 00, 35), y: 23.0);
      store.add(MockFigure());
      store.add(MockFigure());
      final hitAnchor = store.getAnchorByCoord(tapCoord);
      expect(hitAnchor, isNull);
    });
  });
}

void testAddingFigure() {
  test("test adding a Figure to the FigureStore", () {
    final fig1 = generateFigure(10, 10);
    final fig2 = generateFigure(4, 3);
    final store = FigureStore();
    store.add(fig1);
    store.add(fig2);
    expect(store.figures.length, equals(2));
    expect(store.figures.contains(fig1), equals(true));
    expect(store.figures.contains(fig2), equals(true));
  });
}
