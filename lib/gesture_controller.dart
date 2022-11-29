import 'package:flutter/widgets.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/user_interaction.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

class GestureController {
  final UserInteraction _interactor;
  CoordTranslater? _translator;
  DrawZone? drawZone;

  GestureController({CoordTranslater? translator, UserInteraction? interactor})
      : _translator = translator,
        _interactor = interactor ?? UserInteraction(2);
  bool _hasMoved = false;

  void onTapDown(TapDownDetails event) {
    _hasMoved = false;
  }

  void onTapUp(TapUpDetails event) {
    if (_hasMoved) return;
    if (!_isInDrawZone(event.localPosition)) return;
    final vCoord = _convertToVirtual(event.localPosition);
    if (vCoord == null) return;
    _interactor.onTap(vCoord);
  }

  void onDrag(DragUpdateDetails event) {
    _hasMoved = true;
    if (!_isInDrawZone(event.localPosition)) return;
    final vCoord = _convertToVirtual(event.localPosition);
    if (vCoord == null) return;
    _interactor.onDrag(vCoord);
  }

  bool _isInDrawZone(Offset position) {
    return drawZone?.toRect.contains(position) ?? false;
  }

  VirtualCoord? _convertToVirtual(Offset position) {
    return _translator?.toVirtual(position);
  }

  updateTranslator(CoordTranslater translater) => _translator = translater;
}
