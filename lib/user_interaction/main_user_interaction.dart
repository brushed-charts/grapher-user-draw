import 'package:grapher/kernel/propagator/multi.dart';
import 'package:grapher/reference/reader.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/anchor_selection_condition.dart';
import 'package:grapher_user_draw/user_interaction/bypass_pointer_event.dart';
import 'package:grapher_user_draw/user_interaction/gesture_interpreter.dart';
import 'package:grapher_user_draw/user_interaction/interaction_controller.dart';
import 'package:grapher_user_draw/user_interaction/interaction_reference.dart';
import 'package:grapher_user_draw/user_interaction/keyboard_controller.dart';
import 'package:grapher_user_draw/user_interaction/pointer_controller.dart';
import 'package:grapher_user_draw/user_interaction/pointer_convertion_logic.dart';

import '../coord_translater.dart';

class UserInteraction extends Viewable with MultiPropagator {
  final FigureStore store;
  final ReferenceReader<PointerEventBypassChild> refPointerBypass;
  final PointerConvertionLogic pointerConvertion = PointerConvertionLogic();
  final selectionCondition = AnchorYSelectionCondition();

  late final PointerController pointerController;
  late final KeyboardController keyboardController;
  late final InteractionController interactionController;
  late final InteractionReference interactionReference;
  late final GestureInterpreter gestureInterpreter;

  UserInteraction({required this.store, required this.refPointerBypass}) {
    init();
    addControllerAsChildren();
  }

  void init() {
    interactionReference = InteractionReference(
        store, AnchorYSelectionCondition(), refPointerBypass);

    gestureInterpreter = GestureInterpreter(
        interactionReference: interactionReference,
        zoneConverter: pointerConvertion,
        refGraphDragBlocker: refPointerBypass);

    interactionController = InteractionController(interactionReference);

    keyboardController =
        KeyboardController(interactionReference: interactionReference);
    pointerController = PointerController(gestureInterpreter);
  }

  void addControllerAsChildren() {
    children.add(interactionController);
    children.add(pointerController);
    children.add(keyboardController);
  }

  @override
  void draw(ViewEvent viewEvent) {
    super.draw(viewEvent);
    final coordTranslator = CoordTranslater(viewEvent.xAxis, viewEvent.yAxis);
    pointerConvertion.refresh(coordTranslator, viewEvent.drawZone.toRect);
    selectionCondition.updateCoordTranslater(coordTranslator);
    propagate(viewEvent);
  }
}
