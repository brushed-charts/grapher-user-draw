import 'package:flutter/widgets.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/interaction_reference.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

class GestureController extends GraphObject with EndlinePropagator {
  final InteractionReference _interactorRef;
  CoordTranslater? _translator;
  DrawZone? _drawZone;
  bool _hasMoved = false;

  GestureController(
      {CoordTranslater? translator,
      required InteractionReference interactionReference})
      : _translator = translator,
        _interactorRef = interactionReference {
    _registerGestureController();
  }

  void _registerGestureController() {
    eventRegistry.add(TapDownDetails, (p0) => onTapDown(p0));
    eventRegistry.add(DragUpdateDetails, (p0) => onDrag(p0));
  }

  void onTapDown(TapDownDetails event) {
    _hasMoved = false;
  }

  void onTapUp(TapUpDetails event) {
    if (_hasMoved) return;
    if (!_isInDrawZone(event.localPosition)) return;
    final vCoord = _convertToVirtual(event.localPosition);
    if (vCoord == null) return;
    _interactorRef.interface.onTap(vCoord);
    setState(this);
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
