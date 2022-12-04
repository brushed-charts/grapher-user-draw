import 'anchor.dart';
import 'misc.dart';

class Figure {
  final groupID = Misc.generateUniqueID();
  final _anchors = <Anchor>[];
  final int maxLength;
  int get length => _anchors.length;
  bool contains(Anchor anchor) => _anchors.contains(anchor);

  Figure(this.maxLength) {
    if (maxLength <= 0) {
      throw ArgumentError("Figure can't have a max length less that 1");
    }
  }

  void add(Anchor anchor) {
    if (_anchors.length == maxLength) {
      throw StateError("The figure reach the anchor count limit");
    }
    _anchors.add(anchor);
  }

  bool isFull() {
    if (_anchors.length == maxLength) return true;
    return false;
  }

  List<Anchor> getAll() => _anchors;

  List<Anchor> getByDatetime(DateTime date) {
    return _anchors.where((anchor) => anchor.x == date).toList();
  }
}
