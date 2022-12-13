import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/multi.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/figure_database_interface.dart';
import 'package:grapher_user_draw/presenter.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/main_userinteraction.dart';

class GrapherUserDraw extends Viewable with MultiPropagator {
  final FigureStore store;
  final FigureDatabaseInterface figureDatabase;

  GrapherUserDraw(
      {required DrawPresenter drawPresenter,
      required UserInteraction interaction,
      required this.store,
      required this.figureDatabase}) {
    _addChildren(interaction, drawPresenter);
    _populateFromDatabase();
  }

  void _addChildren(UserInteraction interaction, DrawPresenter drawPresenter) {
    children = <GraphObject>[];
    children.add(interaction);
    children.add(drawPresenter);
  }

  void _populateFromDatabase() {
    final loadedFigures = figureDatabase.load();
    store.populate(loadedFigures);
  }

  @override
  void draw(ViewEvent viewEvent) {
    super.draw(viewEvent);
    propagate(viewEvent);
  }
}
