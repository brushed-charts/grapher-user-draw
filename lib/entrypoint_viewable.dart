import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/multi.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/presenter.dart';
import 'package:grapher_user_draw/user_interaction/main_userinteraction.dart';

class GrapherUserDraw extends Viewable with MultiPropagator {
  late final DrawPresenter drawPresenter;
  final UserInteraction interaction;

  GrapherUserDraw(
      {required this.interaction, required DrawPresenter drawPresenter}) {
    children = <GraphObject>[];
    children.add(interaction);
    children.add(drawPresenter);
  }

  @override
  void draw(ViewEvent viewEvent) {
    super.draw(viewEvent);
    propagate(viewEvent);
  }
}
