import 'package:connect4/data.dart';

class Player {
  int player;

  void alternatePlayer() {
    player = player == PlayerColor.red ? PlayerColor.yellow : PlayerColor.red;
  }

  Player(this.player);
}
