import 'package:flutter/services.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/endline.dart';

import 'figure_deletion_interface.dart';

class KeyboardController extends GraphObject with EndlinePropagator {
  final FigureDeletionInterface figureDeletion;
  KeyboardController({required this.figureDeletion}) {
    eventRegistry.add(KeyDownEvent, (p0) => onKeyDown(p0));
  }

  void onKeyDown(KeyDownEvent key) => figureDeletion.delete();
}
