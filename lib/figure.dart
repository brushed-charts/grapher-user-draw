import 'package:flutter/foundation.dart';
import 'package:grapher_user_draw/draw_tools/draw_tool_interface.dart';

import 'anchor.dart';
import 'misc.dart';

class Figure {
  final int groupID;
  final _anchors = <Anchor>[];
  final DrawToolInterface tool;
  int get maxLength => tool.maxLength;
  int get length => _anchors.length;
  String get type => tool.name;
  bool contains(Anchor anchor) => _anchors.contains(anchor);

  Figure(this.tool, [int? groupID])
      : groupID = groupID ?? Misc.generateUniqueID() {
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

  void replace(Anchor anchorToReplace, Anchor newAnchor) {
    final targetIndex = _anchors.indexOf(anchorToReplace);
    if (targetIndex == -1) return;
    _anchors[targetIndex] = newAnchor;
  }

  @override
  bool operator ==(covariant Figure other) {
    if (!listEquals(other._anchors, _anchors)) return false;
    if (other.groupID != groupID) return false;
    if (other.type != type) return false;
    if (other.length != length) return false;
    if (other.maxLength != maxLength) return false;
    return true;
  }

  @override
  int get hashCode => Object.hash(groupID, tool, _anchors);

  @override
  String toString() {
    return "{groupID: $groupID, maxLength: $maxLength, length: $length, toolName: $type, anchors: $_anchors}";
  }
}
