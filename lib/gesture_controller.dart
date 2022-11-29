import 'package:flutter/widgets.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/user_interaction/holder_user_interaction.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

class GestureController {
  final UserInteractionHolder _interactorHolder;
  CoordTranslater? _translator;
  DrawZone? _drawZone;
  bool _hasMoved = false;

  GestureController(
      {CoordTranslater? translator,
      required UserInteractionHolder interactionHolder})
      : _translator = translator,
        _interactorHolder = interactionHolder;

  void onTapDown(TapDownDetails event) {
    _hasMoved = false;
  }

  void onTapUp(TapUpDetails event) {
    if (_hasMoved) return;
    if (!_isInDrawZone(event.localPosition)) return;
    final vCoord = _convertToVirtual(event.localPosition);
    if (vCoord == null) return;
    _interactorHolder.interface.onTap(vCoord);
  }

  void onDrag(DragUpdateDetails event) {
    _hasMoved = true;
    if (!_isInDrawZone(event.localPosition)) return;
    final vCoord = _convertToVirtual(event.localPosition);
    if (vCoord == null) return;
    _interactorHolder.interface.onDrag(vCoord);
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
