import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher_user_draw/draw_tools/draw_tool_event.dart';
import 'package:grapher_user_draw/interaction_reference.dart';

class InteractionController extends GraphObject with EndlinePropagator {
  final InteractionReference interactionRef;
  InteractionController(this.interactionRef) {
    eventRegistry.add(DrawToolEvent, (p0) => _onDrawToolEvent(p0));
  }

  void _onDrawToolEvent(DrawToolEvent event) {
    interactionRef.tool = event.tool;
  }
}
