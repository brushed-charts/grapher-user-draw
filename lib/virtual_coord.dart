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

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => "VirtualCoord(x:$x, y:$y)";
}
