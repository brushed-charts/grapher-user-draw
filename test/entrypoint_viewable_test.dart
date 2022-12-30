import 'package:flutter_test/flutter_test.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher_user_draw/entrypoint_viewable.dart';
import 'package:grapher_user_draw/figure.dart';
import 'package:grapher_user_draw/figure_database_interface.dart';
import 'package:grapher_user_draw/presenter.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/main_userinteraction.dart';
import 'package:mocktail/mocktail.dart';

class MockFigureStore extends Mock implements FigureStore {}

class MockDrawPresenter extends Mock implements DrawPresenter {}

class MockUserInteraction extends Mock implements UserInteraction {}

class MockFigureDatabase extends Mock implements FigureDatabaseInterface {}

class MockViewEvent extends Mock implements ViewEvent {}

class MockFigure extends Mock implements Figure {}

void main() {
  final mockStore = MockFigureStore();
  final mockDatabase = MockFigureDatabase();
  final mockInteraction = MockUserInteraction();
  final mockDrawPresenter = MockDrawPresenter();
  final mockFigure = MockFigure();
  when(mockDatabase.load).thenReturn([mockFigure]);

  GrapherUserDraw(
      drawPresenter: mockDrawPresenter,
      interaction: mockInteraction,
      store: mockStore,
      figureDatabase: mockDatabase);
  test("Verify that the store is populated by loading figure database", () {
    final storeCallResult = verify(() => mockStore.populate(captureAny()));
    storeCallResult.called(1);
    final capturedFigures = storeCallResult.captured[0] as List<Figure>;
    expect(capturedFigures[0], equals(mockFigure));
    verify(() => mockDatabase.load()).called(1);
  });
}
