import 'package:flutter/widgets.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/multi.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/gesture_controller.dart';
import 'package:grapher_user_draw/interaction_reference.dart';
import 'package:grapher_user_draw/pointer_controller.dart';
import 'package:grapher_user_draw/presenter.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/interaction_controller.dart';

class GrapherUserDraw extends Viewable with MultiPropagator {
  late final GestureController _gestureController;
  late final DrawPresenter _drawPresenter;
  final FigureStore _store = FigureStore();
  final _interactionRef = InteractionReference();

  GrapherUserDraw(
      {GestureController? gestureController, DrawPresenter? drawPresenter}) {
    _drawPresenter = drawPresenter ?? DrawPresenter(_store);
    _gestureController = gestureController ??
        GestureController(interactionReference: _interactionRef);
    children = <GraphObject>[];
    children.add(InteractionController(_interactionRef));
    children.add(PointerController(_gestureController));
  }

  @override
  void draw(covariant ViewEvent viewEvent) {
    super.draw(viewEvent);
    final coordTranslator = CoordTranslater(viewEvent.xAxis, viewEvent.yAxis);
    _gestureController.updateTranslator(coordTranslator);
    _gestureController.updateDrawZone(viewEvent.drawZone);
    _drawPresenter.draw(viewEvent);
  }
}
