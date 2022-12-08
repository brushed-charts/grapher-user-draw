import 'package:flutter/services.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher_user_draw/user_interaction/interaction_reference.dart';

class KeyboardController extends GraphObject with EndlinePropagator {
  final InteractionReference interactionReference;
  KeyboardController({required this.interactionReference}) {
    eventRegistry.add(KeyDownEvent, (p0) => onKeyDown(p0));
  }

  void onKeyDown(KeyDownEvent key) {
    interactionReference.interface.delete();
    setState(this);
  }
}
