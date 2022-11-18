import 'anchor.dart';
import 'misc.dart';

class Figure {
  final groupID = Misc.generateUniqueID();
  final _anchors = <Anchor>[];
  final int? maxLength;
  get length => _anchors.length;

  Figure(this.maxLength);

  void add(Anchor anchor) {
    if (_anchors.length == maxLength) {
      throw StateError("The figure reach the anchor count limit");
    }
    _anchors.add(anchor);
  }
}
