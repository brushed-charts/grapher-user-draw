import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/creation_interaction.dart';
import 'package:grapher_user_draw/user_interaction/edition_interaction.dart';
import 'package:grapher_user_draw/user_interaction/user_interaction_interface.dart';

import '../draw_tools/draw_tool_interface.dart';

class InteractionReference extends Viewable with EndlinePropagator {
  DrawToolInterface? _tool;
  CoordTranslater? _coordTranslater;
  set tool(DrawToolInterface? tool) => _updateTool(tool);
  DrawToolInterface? get tool => _tool;

  UserInteractionInterface interface;
  final FigureStore _store;

  InteractionReference(this._store)
      : interface = EditionInteraction(_store, null);

  void _updateTool(DrawToolInterface? tool) {
    _tool = tool;
    if (tool == null) {
      interface = EditionInteraction(_store, _coordTranslater);
      return;
    }
    interface = CreationInteraction(tool.maxLength, _store);
  }

  void updateCoordTranslater(CoordTranslater coordTranslater) {
    _coordTranslater = coordTranslater;
    interface.updateCoordTranslater(coordTranslater);
  }
}