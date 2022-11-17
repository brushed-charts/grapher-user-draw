class VirtualCoord {
  final DateTime x;
  final double y;

  const VirtualCoord(this.x, this.y);
  @override
  bool operator ==(Object other) =>
      other is VirtualCoord &&
      other.runtimeType == runtimeType &&
      other.x == x &&
      other.y == y;

  static VirtualCoord zero() {
    final epochDatetime = DateTime.fromMillisecondsSinceEpoch(0);
    return VirtualCoord(epochDatetime, 0);
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => "VirtualCoord(x:$x, y:$y)";
}
