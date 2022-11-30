import 'package:flutter/widgets.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/kernel/propagator/multi.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/draw_tools/draw_tool_interface.dart';
import 'package:grapher_user_draw/gesture_controller.dart';
import 'package:grapher_user_draw/interaction_reference.dart';
import 'package:grapher_user_draw/presenter.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/creation_interaction.dart';
import 'package:grapher_user_draw/user_interaction/interaction_controller.dart';

class GrapherUserDraw extends Viewable with MultiPropagator {
  late final GestureController _gestureController;
  late final DrawPresenter _drawPresenter;
  final DrawToolInterface _tool;
  final FigureStore _store = FigureStore();
  final _interactionRef = InteractionReference();

  GrapherUserDraw(
      {required DrawToolInterface tool,
      GestureController? gestureController,
      DrawPresenter? drawPresenter})
      : _tool = tool {
    _drawPresenter = drawPresenter ?? DrawPresenter(_tool, _store);
    _gestureController = gestureController ??
        GestureController(interactionReference: _interactionRef);
    registerGestureController();
    children = <GraphObject>[];
    _interactionRef.tool = _tool;
    _interactionRef.interface = CreationInteraction(3, _store);
    children.add(InteractionController(_interactionRef));
  }

  void registerGestureController() {
    eventRegistry.add(TapDownDetails, (p0) => _gestureController.onTapDown(p0));
    eventRegistry.add(DragUpdateDetails, (p0) => _gestureController.onDrag(p0));
    eventRegistry.add(TapUpDetails, (p0) => handleTapUp(p0));
  }

  @override
  void draw(covariant ViewEvent viewEvent) {
    super.draw(viewEvent);
    final coordTranslator = CoordTranslater(viewEvent.xAxis, viewEvent.yAxis);
    _gestureController.updateTranslator(coordTranslator);
    _gestureController.updateDrawZone(viewEvent.drawZone);
    _drawPresenter.draw(viewEvent);
  }

  void handleTapUp(TapUpDetails event) {
    _gestureController.onTapUp(event);
    setState(this);
  }
}
