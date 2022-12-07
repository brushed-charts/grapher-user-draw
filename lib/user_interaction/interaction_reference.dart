import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/reference/reader.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/bypass_pointer_event.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/anchor_selection_condition.dart';
import 'package:grapher_user_draw/user_interaction/creation_interaction.dart';
import 'package:grapher_user_draw/user_interaction/edition_interaction.dart';
import 'package:grapher_user_draw/user_interaction/user_interaction_interface.dart';

import '../draw_tools/draw_tool_interface.dart';

class InteractionReference extends Viewable with EndlinePropagator {
  DrawToolInterface? _tool;
  UserInteractionInterface interface;
  final FigureStore _store;
  final AnchorYSelectionCondition _anchorSelectCondition;
  final ReferenceReader<PointerEventBypassChild> _refPointerBypass;

  InteractionReference(
      this._store, this._anchorSelectCondition, this._refPointerBypass)
      : interface = EditionInteraction(
          _store,
          _anchorSelectCondition,
          _refPointerBypass,
        );

  void _updateTool(DrawToolInterface? tool) {
    _tool = tool;
    if (tool == null) {
      interface = EditionInteraction(
        _store,
        _anchorSelectCondition,
        _refPointerBypass,
      );
      return;
    }
    interface = CreationInteraction(tool, _store);
  }

  set tool(DrawToolInterface? tool) => _updateTool(tool);
  DrawToolInterface? get tool => _tool;
}
