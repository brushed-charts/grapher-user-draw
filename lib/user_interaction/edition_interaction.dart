import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/anchor_range_selection.dart';
import 'package:grapher_user_draw/user_interaction/user_interaction_interface.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

import '../anchor.dart';

class EditionInteraction implements UserInteractionInterface {
  final FigureStore _store;
  final AnchorRangeSelection _anchorSelector;
  Anchor? _anchorSelected;

  EditionInteraction(this._store, this._anchorSelector);

  @override
  void onTap(VirtualCoord coord) {
    final matchingAnchors = _store.getByDatetime(coord.x);
    _anchorSelected = null;
    for (final anchor in matchingAnchors) {
      if (!_anchorSelector.isCloseToPointer(coord.y, anchor.y)) continue;
      _anchorSelected = anchor;
    }
  }

  @override
  void onDrag(VirtualCoord coord) {}

  Anchor? get anchorSelected => _anchorSelected;
}
