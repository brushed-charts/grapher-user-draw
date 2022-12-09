import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/multi.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/presenter.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/main_user_interaction.dart';

class GrapherUserDraw extends Viewable with MultiPropagator {
  late final DrawPresenter drawPresenter;
  final FigureStore store;
  final UserInteraction? interaction;

  GrapherUserDraw(
      {this.interaction, DrawPresenter? drawPresenter, required this.store}) {
    drawPresenter = drawPresenter ?? DrawPresenter(store);
    children = <GraphObject>[];
    if (interaction != null) children.add(interaction!);
    children.add(drawPresenter);
  }

  @override
  void draw(ViewEvent viewEvent) {
    super.draw(viewEvent);
    propagate(viewEvent);
  }
}
