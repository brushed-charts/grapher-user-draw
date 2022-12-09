import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/multi.dart';
import 'package:grapher/reference/reader.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/bypass_pointer_event.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/gesture_interpreter.dart';
import 'package:grapher_user_draw/keyboard_controller.dart';
import 'package:grapher_user_draw/pointer_convertion_logic.dart';
import 'package:grapher_user_draw/user_interaction/anchor_selection_condition.dart';
import 'package:grapher_user_draw/user_interaction/interaction_reference.dart';
import 'package:grapher_user_draw/pointer_controller.dart';
import 'package:grapher_user_draw/presenter.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/interaction_controller.dart';

class GrapherUserDraw extends Viewable with MultiPropagator {
  late final GestureInterpreter _gestureController;
  late final DrawPresenter _drawPresenter;
  final FigureStore _store = FigureStore();
  final _anchorSelectCondition = AnchorYSelectionCondition();
  late final _interactionRef =
      InteractionReference(_store, _anchorSelectCondition, _pointerBypassRef);
  final ReferenceReader<PointerEventBypassChild> _pointerBypassRef;
  late final KeyboardController _keyboardController;
  final _pointerConverter = PointerConvertionLogic();

  GrapherUserDraw(
      {required ReferenceReader<PointerEventBypassChild> pointerBypass,
      GestureInterpreter? gestureController,
      KeyboardController? keyboardController,
      DrawPresenter? drawPresenter})
      : _pointerBypassRef = pointerBypass {
    _keyboardController = keyboardController ??
        KeyboardController(interactionReference: _interactionRef);
    _drawPresenter = drawPresenter ?? DrawPresenter(_store);
    _gestureController = gestureController ??
        GestureInterpreter(
            zoneConverter: _pointerConverter,
            refGraphDragBlocker: _pointerBypassRef,
            interactionReference: _interactionRef);
    children = <GraphObject>[];
    children.add(InteractionController(_interactionRef));
    children.add(PointerController(_gestureController));
    children.add(_gestureController);
    children.add(_keyboardController);
    children.add(_drawPresenter);
  }

  @override
  void draw(ViewEvent viewEvent) {
    super.draw(viewEvent);
    final coordTranslator = CoordTranslater(viewEvent.xAxis, viewEvent.yAxis);
    _pointerConverter.refresh(coordTranslator, viewEvent.drawZone.toRect);
    _anchorSelectCondition.updateCoordTranslater(coordTranslator);
    propagate(viewEvent);
  }
}
