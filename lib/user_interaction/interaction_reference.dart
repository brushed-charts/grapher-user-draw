import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/reference/reader.dart';
import 'package:grapher/view/viewable.dart';
import 'package:grapher_user_draw/example/main.dart';
import 'package:grapher_user_draw/figure_database_interface.dart';
import 'package:grapher_user_draw/user_interaction/bypass_pointer_event.dart';
import 'package:grapher_user_draw/user_interaction/figure_deletion_interface.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/anchor_selection_condition.dart';
import 'package:grapher_user_draw/user_interaction/creation_interaction.dart';
import 'package:grapher_user_draw/user_interaction/drag_interaction_interface.dart';
import 'package:grapher_user_draw/user_interaction/edition_interaction.dart';
import 'package:grapher_user_draw/user_interaction/tap_interaction_interface.dart';

import '../draw_tools/draw_tool_interface.dart';

class InteractionReference extends Viewable with EndlinePropagator {
  DrawToolInterface? _tool;
  late TapInteractionInterface tapInterface;
  late DragInteractionInterface? dragInterface;
  late FigureDeletionInterface? deleteInterface;
  final FigureStore _store;
  final AnchorYSelectionCondition _anchorSelectCondition;
  final ReferenceReader<PointerEventBypassChild> _refPointerBypass;
  final FigureDatabaseInterface _figureDatabase;

  InteractionReference(this._store, this._anchorSelectCondition,
      this._refPointerBypass, this._figureDatabase)
      : tapInterface = EditionInteraction(
            _store, _anchorSelectCondition, _refPointerBypass, _figureDatabase);

  void _updateTool(DrawToolInterface? tool) {
    _tool = tool;
    _trySitchingToEdition();
    _trySwitchingToCreation();
  }

  void _trySwitchingToCreation() {
    if (_tool == null) return;
    tapInterface = CreationInteraction(_tool!, _store, _figureDatabase);
    dragInterface = null;
    deleteInterface = null;
  }

  void _trySitchingToEdition() {
    if (_tool != null) return;
    final edition = EditionInteraction(
        _store, _anchorSelectCondition, _refPointerBypass, _figureDatabase);
    tapInterface = edition;
    dragInterface = edition;
    deleteInterface = edition;
  }

  set tool(DrawToolInterface? tool) => _updateTool(tool);
  DrawToolInterface? get tool => _tool;
}
