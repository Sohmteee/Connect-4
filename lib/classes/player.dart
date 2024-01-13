import 'package:connect4/data.dart';

class Player {
  PlayerColor color;

  void alternatePlayer() {
    color = color == PlayerColor.red ? PlayerColor.yellow : PlayerColor.red;
  }

  Player(this.color);
}
