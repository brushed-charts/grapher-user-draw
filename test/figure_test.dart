import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/anchor.dart';
import 'package:grapher_user_draw/figure.dart';
import 'package:mocktail/mocktail.dart';

class MockAnchor extends Mock implements Anchor {}

void main() {
  const fiveAnchorsCount = 5;
  late Figure figureLength4, figureLength5, figureLength2;
  final anchorA = Anchor(x: DateTime(2022, 11, 19, 19), y: 7857);
  final anchorB = Anchor(x: DateTime(2022, 12, 3, 02), y: 7857);
  final anchorC = Anchor(x: DateTime(2022, 11, 19, 19), y: 893);

  setUp(() {
    figureLength2 = Figure(2);
    figureLength4 = Figure(4);
    figureLength5 = Figure(5);
  });

  test("Assert Figure can't have a less than one anchor", () {
    expect(() => Figure(0), throwsArgumentError);
    expect(() => Figure(-1), throwsArgumentError);
    expect(() => Figure(1), returnsNormally);
  });

  group('Test adding anchor intto the figure', () {
    test('if anchor count don\'t reach the limit', () {
      addAnchorsToFigure(fiveAnchorsCount, figureLength5);
      expect(figureLength5.length, equals(fiveAnchorsCount));
    });
    test('if anchor count exceed the limit length', () {
      exceededAnchorLimit() =>
          addAnchorsToFigure(fiveAnchorsCount, figureLength4);
      expect(exceededAnchorLimit, throwsStateError);
    });
  });

  test('Assert figure creation generate an unique GroupID', () {
    expect(figureLength4.groupID, isNot(equals(figureLength5.groupID)));
  });

  group('Assert figure full function return', () {
    test('true when anchor count reach the limit', () {
      addAnchorsToFigure(4, figureLength4);
      expect(figureLength4.isFull(), isTrue);
    });
    test('false when figure still have room', () {
      addAnchorsToFigure(3, figureLength4);
      expect(figureLength4.isFull(), isFalse);
    });
  });

  group('Inside Figure assert anchor is', () {
    final anchorB = Anchor(x: DateTime(2022, 11, 19, 10), y: 757);
    test('present after added it', () {
      figureLength2.add(anchorA);
      figureLength2.add(anchorB);
      expect(figureLength2.contains(anchorB), isTrue);
    });
    test('not present when anchors are differents', () {
      figureLength2.add(anchorA);
      expect(figureLength2.contains(anchorB), isFalse);
    });
    test('not present when nothing was added', () {
      expect(figureLength2.contains(anchorB), isFalse);
    });
    test('present although objects are differents but with the same value', () {
      final anchorB = Anchor(x: anchorA.x, y: anchorA.y);
      figureLength2.add(anchorA);
      expect(figureLength2.contains(anchorB), isTrue);
    });
  });

  test("Assert getAll() function of figure return the anchor list", () {
    figureLength2.add(anchorA);
    figureLength2.add(anchorB);
    expect(figureLength2.getAll(), equals([anchorA, anchorB]));
  });

  group("Check Figure getByDatetime() returned anchor", () {
    test('when anchors is present', () {
      final searchDateMatchingAnchor = DateTime(2022, 11, 19, 19);
      figureLength4.add(anchorA);
      figureLength4.add(anchorB);
      figureLength4.add(anchorC);
      expect(figureLength4.getByDatetime(searchDateMatchingAnchor),
          equals([anchorA, anchorC]));
    });
    test("when no anchor match", () {
      final dateWithoutOccurence = DateTime(2022, 12, 04, 00, 54);
      figureLength4.add(anchorA);
      figureLength4.add(anchorB);
      expect(figureLength4.getByDatetime(dateWithoutOccurence), equals([]));
    });
  });

  group("In Figure, assert anchor replacement", () {
    test("is done when Anchor to replace exist", () {
      figureLength2.add(anchorA);
      figureLength2.replace(anchorA, anchorB);
      expect(figureLength2.contains(anchorA), isFalse);
      expect(figureLength2.contains(anchorB), isTrue);
    });

    test("do nothing when anchor to replace do not exist", () {
      figureLength2.add(anchorC);
      figureLength2.replace(anchorA, anchorB);
      expect(figureLength2.contains(anchorA), isFalse);
      expect(figureLength2.contains(anchorB), isFalse);
      expect(figureLength2.contains(anchorC), isTrue);
    });
  });
}

void addAnchorsToFigure(int anchorCount, Figure figure) {
  for (int i = 0; i < anchorCount; i++) {
    figure.add(MockAnchor());
  }
}
