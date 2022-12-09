import 'dart:ui';

import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

import 'coord_translater.dart';

class PointerConvertionLogic {
  DrawZone? _drawZone;
  CoordTranslater? _translator;

  VirtualCoord? toVirtual(Offset pixelPosition) {
    _throwIfNotInit();
    if (!_isInDrawZone(pixelPosition)) return null;
    final vCoord = _convertToVirtual(pixelPosition);
    return vCoord;
  }

  bool _isInDrawZone(Offset position) {
    return _drawZone!.toRect.contains(position);
  }

  VirtualCoord? _convertToVirtual(Offset position) {
    return _translator!.toVirtual(position);
  }

  void _throwIfNotInit() {
    if (_drawZone != null && _translator != null) return;
    throw StateError("The drawZone and coordTranslater should be init "
        "before user can interact with the graph. "
        "It is probably due to a draw event that doesn't occured");
  }

  refresh(CoordTranslater translater, DrawZone drawZone) {
    _translator = translater;
    _drawZone = drawZone;
  }
}
