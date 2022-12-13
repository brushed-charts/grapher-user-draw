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
    if (!isADeletionKey(key)) return;
    final objectDeletion = interactionReference.deleteInterface;
    if (objectDeletion == null) return;
    objectDeletion.delete();
    setState(this);
  }

  bool isADeletionKey(KeyDownEvent key) {
    if (key.logicalKey == LogicalKeyboardKey.backspace) return true;
    if (key.logicalKey == LogicalKeyboardKey.delete) return true;
    return false;
  }
}
