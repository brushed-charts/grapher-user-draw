import 'package:flutter_test/flutter_test.dart';
import 'package:grapher_user_draw/core/anchor_2d.dart';
import 'package:grapher_user_draw/logic/figure.dart';
import 'package:grapher_user_draw/logic/store.dart';
import 'package:grapher_user_draw/logic/virtual_coord.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  testStoreGetAnchorByCoord();
}

void testStoreGetAnchorByCoord() {
  group("Test FigureStore: getAnchorByCoord() when:", () {
    test("tapCoord is pointing to an anchor", () {
      final store = FigureStore();
      final tapCoord = VirtualCoord(x: DateTime(2022, 11, 07, 00, 35), y: 23.0);
      final knownFigure = MockFigure();
      final knownAnchor = Anchor2D(12345, DateTime(2022, 11, 07, 00, 35), 23);
      when(() => knownFigure.getHitObject(tapCoord)).thenReturn(knownAnchor);
      store.add(MockFigure());
      store.add(knownFigure);
      store.add(MockFigure());
      final hitAnchor = store.getAnchorByCoord(tapCoord);
      expect(hitAnchor, equals(knownAnchor));
    });
    test('taCoord is pointing to nothing', () {
      final store = FigureStore();
      final tapCoord = VirtualCoord(x: DateTime(2022, 11, 07, 00, 35), y: 23.0);
      store.add(MockFigure());
      store.add(MockFigure());
      final hitAnchor = store.getAnchorByCoord(tapCoord);
      expect(hitAnchor, isNull);
    });
  });
}

class MockFigure extends Mock implements Figure {}
