import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/store.dart';
import 'package:grapher_user_draw/user_interaction/user_interaction_interface.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

import '../anchor.dart';

class EditionInteraction implements UserInteractionInterface {
  static const double _selectionRange = 15;
  final FigureStore _store;
  Anchor? _anchorSelected;
  CoordTranslater? coordTranslater;

  EditionInteraction(this._store, this.coordTranslater);

  @override
  void onTap(VirtualCoord coord) {
    final matchingAnchors = _store.getByDatetime(coord.x);
    _anchorSelected = null;
    for (final anchor in matchingAnchors) {
      if (!_isAnchorInSelectionRange(anchor.y, coord.y)) continue;
      _anchorSelected = anchor;
    }
  }

  @override
  void onDrag(VirtualCoord coord) {}

  bool _isAnchorInSelectionRange(double virtualAnchorY, double virtualTapY) {
    if (coordTranslater == null) return false;
    final pixelTapY = coordTranslater!.yAxis.toPixel(virtualTapY);
    final pixelAnchorY = coordTranslater!.yAxis.toPixel(virtualAnchorY);

    final distance = (pixelAnchorY - pixelTapY).abs();
    if (distance <= _selectionRange) return true;
    return false;
  }

  @override
  void updateCoordTranslater(CoordTranslater translater) {
    coordTranslater = translater;
  }

  Anchor? get anchorSelected => _anchorSelected;
}
