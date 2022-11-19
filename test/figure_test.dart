import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/anchor.dart';
import 'package:grapher_user_draw/figure.dart';
import 'package:mocktail/mocktail.dart';

class MockAnchor extends Mock implements Anchor {}

void main() {
  testPathCreation();
  testFigureGroupIDGeneration();
  testFigureIsFull();
}

void testPathCreation() {
  group('Test adding anchor intto the figure', () {
    const anchorCount = 5;
    test('if anchor count don\'t reach the limit', () {
      final figure = Figure(anchorCount);
      addAnchorsToFigure(anchorCount, figure);
      expect(figure.length, equals(anchorCount));
    });
    test('if anchor count exceed the limit length', () {
      const figureLength = 4;
      final fig = Figure(figureLength);
      expect(() => addAnchorsToFigure(anchorCount, fig), throwsStateError);
    });
  });
}

void testFigureGroupIDGeneration() {
  test('Assert figure creation generate an unique GroupID', () {
    const figLength = 3;
    final fig1 = Figure(figLength);
    final fig2 = Figure(figLength);
    expect(fig1.groupID, isNot(equals(fig2.groupID)));
  });
}

void testFigureIsFull() {
  group('Assert figure full function return', () {
    test('true when anchor count reach the limit', () {
      final figure = Figure(4);
      addAnchorsToFigure(4, figure);
      expect(figure.isFull(), isTrue);
    });
    test('false when figure still have room', () {
      final figure = Figure(4);
      addAnchorsToFigure(3, figure);
      expect(figure.isFull(), isFalse);
    });
  });
}

void addAnchorsToFigure(int anchorCount, Figure figure) {
  for (int i = 0; i < anchorCount; i++) {
    figure.add(MockAnchor());
  }
}
