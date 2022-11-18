class Anchor {
  final DateTime x;
  final double y;

  Anchor({required this.x, required this.y});

  @override
  bool operator ==(covariant Anchor other) {
    if (other.x != x) return false;
    if (other.y != y) return false;
    return true;
  }

  @override
  int get hashCode => Object.hash(x, y);
}
