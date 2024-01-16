import 'package:connect4/data.dart';

class Player {
  int number;
  String? name;
  int? score;

  String boardToString() => gameBoard.map((row) => row.join()).join();

  Player(this.number);
}
