import 'package:flutter/widgets.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/draw_tools/draw_tool_interface.dart';
import 'package:grapher_user_draw/gesture_controller.dart';
import 'package:grapher_user_draw/presenter.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/creation_interaction.dart';
import 'package:grapher_user_draw/user_interaction/user_interaction_interface.dart';

class GrapherUserDraw extends Viewable with EndlinePropagator {
  late final GestureController _gestureController;
  late final DrawPresenter _drawPresenter;
  final DrawToolInterface _tool;
  final FigureStore _store = FigureStore();
  late UserInteractionInterface _userInteraction;

  GrapherUserDraw({
    required DrawToolInterface tool,
    GestureController? gestureController,
    DrawPresenter? drawPresenter,
  }) : _tool = tool {
    _drawPresenter = drawPresenter ?? DrawPresenter(_tool, _store);
    _userInteraction = CreationInteraction(tool.maxLength, _store);
    _gestureController =
        gestureController ?? GestureController(interactor: _userInteraction);
    registerGestureController();
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
