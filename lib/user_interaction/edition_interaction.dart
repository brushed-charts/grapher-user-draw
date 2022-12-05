import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/anchor_selection_condition.dart';
import 'package:grapher_user_draw/user_interaction/user_interaction_interface.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

import '../anchor.dart';

class EditionInteraction implements UserInteractionInterface {
  final FigureStore _store;
  final AnchorYSelectionCondition _anchorSelectCondition;
  Anchor? _anchorSelected;

  EditionInteraction(this._store, this._anchorSelectCondition);

  @override
  void onTap(VirtualCoord coord) {
    _updateAnchorSelected(coord);
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
  }

  Anchor? get anchorSelected => _anchorSelected;

  @override
  void onDragStart(VirtualCoord coord) {
    _updateAnchorSelected(coord);
  }
}
