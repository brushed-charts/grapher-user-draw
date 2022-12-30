import 'package:grapher/reference/reader.dart';
import 'package:grapher_user_draw/figure_database_interface.dart';
import 'package:grapher_user_draw/user_interaction/bypass_pointer_event.dart';
import 'package:grapher_user_draw/user_interaction/figure_deletion_interface.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/anchor_selection_condition.dart';
import 'package:grapher_user_draw/user_interaction/drag_interaction_interface.dart';
import 'package:grapher_user_draw/user_interaction/tap_interaction_interface.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

import '../anchor.dart';

class EditionInteraction
    implements
        TapInteractionInterface,
        DragInteractionInterface,
        FigureDeletionInterface {
  final FigureStore _store;
  final AnchorYSelectionCondition _anchorSelectCondition;
  final ReferenceReader<PointerEventBypassChild> _refBypassPointer;
  final FigureDatabaseInterface _figureDatabase;
  Anchor? _anchorSelected;
  Anchor? get anchorSelected => _anchorSelected;

  EditionInteraction(this._store, this._anchorSelectCondition,
      this._refBypassPointer, this._figureDatabase);

  @override
  void onTap(VirtualCoord coord) {
    _updateAnchorSelected(coord);
    _refBypassPointer.read()!.disable();
  }

  void _updateAnchorSelected(VirtualCoord pointerCoord) {
    _anchorSelected = null;
    final matchingAnchors = _store.getByDatetime(pointerCoord.x);
    for (final anchor in matchingAnchors) {
      if (_anchorSelectCondition.isCloseToPointer(pointerCoord.y, anchor.y)) {
        _anchorSelected = anchor;
      }
    }
  }

  @override
  void onDrag(VirtualCoord coord) {
    if (anchorSelected == null) return;
    final movedAnchor = Anchor(x: coord.x, y: coord.y);
    final retrievedFigure = _store.getByAnchor(anchorSelected!);
    retrievedFigure!.replace(anchorSelected!, movedAnchor);
    _anchorSelected = movedAnchor;
    _refBypassPointer.read()!.enable();
  }

  @override
  void onDragStart(VirtualCoord coord) {
    _updateAnchorSelected(coord);
  }

  @override
  void delete() {
    if (_anchorSelected == null) return;
    final figureSelected = _store.getByAnchor(_anchorSelected!)!;
    _store.delete(figureSelected.groupID);
    _anchorSelected = null;
    _figureDatabase.delete(figureSelected);
  }

  @override
  void onDragEnd() {
    _refBypassPointer.read()!.disable();
    if (anchorSelected == null) return;
    final figureSelected = _store.getByAnchor(_anchorSelected!);
    _figureDatabase.save(figureSelected!);
  }
}
