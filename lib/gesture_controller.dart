import 'package:flutter/widgets.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/interaction_reference.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

class GestureController {
  final InteractionReference _interactorRef;
  CoordTranslater? _translator;
  DrawZone? _drawZone;
  bool _hasMoved = false;

  GestureController(
      {CoordTranslater? translator,
      required InteractionReference interactionReference})
      : _translator = translator,
        _interactorRef = interactionReference;

  void onTapDown(TapDownDetails event) {
    _hasMoved = false;
  }

  void onTapUp(TapUpDetails event) {
    if (_hasMoved) return;
    if (!_isInDrawZone(event.localPosition)) return;
    final vCoord = _convertToVirtual(event.localPosition);
    if (vCoord == null) return;
    _interactorRef.interface.onTap(vCoord);
  }

  void onDrag(DragUpdateDetails event) {
    _hasMoved = true;
    if (!_isInDrawZone(event.localPosition)) return;
    final vCoord = _convertToVirtual(event.localPosition);
    if (vCoord == null) return;
    _interactorRef.interface.onDrag(vCoord);
  }

  bool _isInDrawZone(Offset position) {
    return _drawZone?.toRect.contains(position) ?? false;
  }

  VirtualCoord? _convertToVirtual(Offset position) {
    return _translator?.toVirtual(position);
  }

  updateTranslator(CoordTranslater translater) => _translator = translater;
  updateDrawZone(DrawZone drawZone) => _drawZone = drawZone;
}
