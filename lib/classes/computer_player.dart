import 'package:connect4/classes/player.dart';
import 'package:connect4/classes/position.dart';
import 'package:connect4/data.dart';

class ComputerPlayer extends Player {
  Position? lastPlayedPosition;
  int humanPlayerNumber;
  ComputerPlayer(super.number, {required this.humanPlayerNumber});

  String boardToString() => gameBoard.map((row) => row.join()).join();

  int play() {
    return 0;
  }
}
