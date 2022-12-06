import 'package:flutter/widgets.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

class PointerEventBypassChild extends GraphObject with SinglePropagator {
  bool _enabled = false;
  bool get isEnabled => _enabled;

  PointerEventBypassChild({required GraphObject child}) {
    this.child = child;
    eventRegistry.add(TapDownDetails, (p0) => _onPointerEvent(p0));
    eventRegistry.add(TapUpDetails, (p0) => _onPointerEvent(p0));
    eventRegistry.add(DragDownDetails, (p0) => _onPointerEvent(p0));
    eventRegistry.add(DragUpdateDetails, (p0) => _onPointerEvent(p0));
    eventRegistry.add(DragStartDetails, (p0) => _onPointerEvent(p0));
    eventRegistry.add(DragEndDetails, (p0) => _onPointerEvent(p0));
  }
  void _onPointerEvent(e) {
    _propagateIfEnabled(e);
    _propagateIfDisabled(e);
  }

  void _propagateIfEnabled(event) {
    if (!_enabled) return;
    child?.propagate(event);
  }

  void _propagateIfDisabled(event) {
    if (_enabled) return;
    propagate(event);
  }

  void disable() => _enabled = false;
  void enable() => _enabled = true;
}
