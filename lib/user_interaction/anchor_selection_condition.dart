import 'package:grapher_user_draw/coord_translater.dart';

class AnchorYSelectionCondition {
  static const double _selectionRange = 25;
  CoordTranslater? _coordTranslater;

  isCloseToPointer(double virtualTapY, double virtualAnchorY) {
    if (_coordTranslater == null) return false;
    final pixelTapY = _coordTranslater!.yAxis.toPixel(virtualTapY);
    final pixelAnchorY = _coordTranslater!.yAxis.toPixel(virtualAnchorY);

    final distance = (pixelAnchorY - pixelTapY).abs();
    if (distance <= _selectionRange) return true;
    return false;
  }

  void updateCoordTranslater(CoordTranslater coordTranslater) {
    _coordTranslater = coordTranslater;
  }
}
