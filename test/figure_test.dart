import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/anchor.dart';
import 'package:grapher_user_draw/figure.dart';
import 'package:mocktail/mocktail.dart';

class MockAnchor extends Mock implements Anchor {}

void main() {
  testPathCreation();
  testFigureGroupIDGeneration();
  testFigureIsFull();
  testIfFigureContainAnAnchor();
  testFigureCantHaveLessThanOneAnchor();
}

void testFigureCantHaveLessThanOneAnchor() {
  test("Assert Figure can't have a less than one anchor", () {
    expect(() => Figure(0), throwsArgumentError);
    expect(() => Figure(-1), throwsArgumentError);
    expect(() => Figure(1), returnsNormally);
  });
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

void testIfFigureContainAnAnchor() {
  group('Inside Figure assert anchor is', () {
    final anchorA = Anchor(x: DateTime(2022, 11, 19, 19), y: 7857);
    test('present after added it', () {
      final figure = Figure(2);
      final anchorB = Anchor(x: DateTime(2022, 11, 19, 10), y: 757);
      figure.add(anchorA);
      figure.add(anchorB);
      expect(figure.contains(anchorB), isTrue);
    });
    test('not present when anchors are differents', () {
      final figure = Figure(2);
      final anchorB = Anchor(x: DateTime(2022, 11, 19, 10), y: 757);
      figure.add(anchorA);
      expect(figure.contains(anchorB), isFalse);
    });
    test('not present when nothing was added', () {
      final figure = Figure(2);
      final anchorB = Anchor(x: DateTime(2022, 11, 19, 10), y: 757);
      expect(figure.contains(anchorB), isFalse);
    });
    test('present although objects are differents but with the same value', () {
      final figure = Figure(2);
      final anchorB = Anchor(x: DateTime(2022, 11, 19, 19), y: 7857);
      figure.add(anchorA);
      expect(figure.contains(anchorB), isTrue);
    });
  });
}

void addAnchorsToFigure(int anchorCount, Figure figure) {
  for (int i = 0; i < anchorCount; i++) {
    figure.add(MockAnchor());
  }
}
