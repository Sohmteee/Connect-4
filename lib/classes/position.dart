class Position {
  int x;
  int y;

  Position(this.x, this.y);

  @override
  String toString() {
    return '[$x, $y]';
  }
}

class PositionsList {
  List<Position> positions;

  PositionsList(this.positions);

  void clear() {
    positions.clear();
  }

  void add(Position position) {
    positions.add(position);
  }

  int size() {
    return positions.length;
  }

  contains(Position position) {
    return positions.any((p) => p.x == position.x && p.y == position.y);
  }

  @override
  String toString() {
    return '[${positions.map((position) => position.toString()).join(', ')}]';
  }
}
