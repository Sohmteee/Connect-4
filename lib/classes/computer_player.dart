import 'package:connect4/classes/player.dart';
import 'package:connect4/data.dart';

class ComputerPlayer extends Player {
  ComputerPlayer(super.number);

  void play() {}

  /// Method to check if the cell has support from the bottom
  bool hasSupport(int rowIndex, int columnIndex) {
    return (rowIndex == 5) ? true : gameBoard[rowIndex + 1][columnIndex] != 0;
  }


  void completeThree() {
    // horizon
  }
}
