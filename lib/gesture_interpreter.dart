import 'package:flutter/widgets.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/reference/reader.dart';
import 'package:grapher_user_draw/bypass_pointer_event.dart';
import 'package:grapher_user_draw/coord_translater.dart';
import 'package:grapher_user_draw/user_interaction/interaction_reference.dart';
import 'package:grapher_user_draw/virtual_coord.dart';

class GestureInterpreter extends GraphObject with EndlinePropagator {
  final InteractionReference _interactorRef;
  CoordTranslater? _translator;
  final ReferenceReader<PointerEventBypassChild> _refGraphDragBlocker;
  DrawZone? _drawZone;
  bool _hasMoved = false;

  GestureInterpreter(
      {required ReferenceReader<PointerEventBypassChild> refGraphDragBlocker,
      CoordTranslater? translator,
      required InteractionReference interactionReference})
      : _refGraphDragBlocker = refGraphDragBlocker,
        _translator = translator,
        _interactorRef = interactionReference;

  void onTapUp(TapUpDetails event) {
    final vCoord = _tryConvertToVirtual(event.localPosition);
    if (vCoord == null) return;
    _interactorRef.tapInterface.onTap(vCoord);
    setState(this);
  }

  void onDrag(DragUpdateDetails event) {
    _callDragStartOnFirstMove(event);
    final vCoord = _tryConvertToVirtual(event.localPosition);
    if (vCoord == null) return;
    _interactorRef.dragInterface?.onDrag(vCoord);
    setState(this);
  }

  void onDragEnd(DragEndDetails event) {
    _hasMoved = false;
    _refGraphDragBlocker.read()!.disable();
  }

  void _callDragStartOnFirstMove(DragUpdateDetails event) {
    if (_hasMoved) return;
    final vCoord = _tryConvertToVirtual(event.localPosition);
    if (vCoord == null) return;
    _interactorRef.dragInterface?.onDragStart(vCoord);
    _hasMoved = true;
  }

  VirtualCoord? _tryConvertToVirtual(Offset pixelPosition) {
    if (!_isInDrawZone(pixelPosition)) return null;
    final vCoord = _convertToVirtual(pixelPosition);
    return vCoord;
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
