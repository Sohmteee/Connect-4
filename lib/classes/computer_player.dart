import 'package:connect4/classes/player.dart';
import 'package:connect4/classes/position.dart';
import 'package:connect4/data.dart';

class ComputerPlayer extends Player {
  Position? lastPlayedPosition;
  int humanPlayerNumber;
  ComputerPlayer(super.number, {required this.humanPlayerNumber});

  void play() {
    // try to win horizontally

    // try to block any win horizontally

    // try to win vertically

    //try to block any win vertically

    // try to win diagonally

    // try to block any win diagonally

    // try to fill in an empty space horizontally
    if (fillEmptySpace(number) != null) {
      // place disk
    }
    if (fillEmptySpace(humanPlayerNumber) != null) {
      // place disk
    }

    // try to complete a pair vertically

    // try to complete a pair horizontally

    // try to complete a pair diagonally

    // try to play next to the last played position horizontally

    // try to play next to the last played position vertically

    // try to play next to the last played position diagonally
  }

  /// Method to check if the cell has support from the bottom
  bool hasSupport(int rowIndex, int columnIndex) {
    return (rowIndex == 5) ? true : gameBoard[rowIndex + 1][columnIndex] != 0;
  }

  void completeHorizontalThree(int targetNumber) {
    getBoundaries(List row, int index) {}

    for (int rowIndex = 5; rowIndex >= 0; rowIndex--) {
      List row = gameBoard[rowIndex];
      int? emptyLeft, emptyRight;
      bool hasFoundNearestEmptyLeft = false;

      // complete a triple

      // complete a pair
    }
  }

  /// Method to place a disk into an empty space either between two disks of
  /// the target color or at the beginning/end of a row if the next disk
  /// has the target color.
  int? fillEmptySpace(int targetNumber) {
    for (int rowIndex = 5; rowIndex >= 0; rowIndex--) {
      List row = gameBoard[rowIndex];
      if (!row.contains(0)) continue;

      for (int columnIndex = 0; columnIndex < row.length - 3; columnIndex++) {
        if (row[columnIndex] == 0) {
          if ((columnIndex > 0 || columnIndex < row.length - 3) &&
              hasSupport(rowIndex, columnIndex)) {
            if (row[columnIndex + 1] == targetNumber &&
                row[columnIndex + 2] == targetNumber) {
              return columnIndex;
            }
          }
          if (columnIndex == 0 && hasSupport(rowIndex, columnIndex)) {
            if (row[columnIndex + 1] == targetNumber) {
              return columnIndex;
            }
          }
          if (columnIndex == row.length - 3 &&
              hasSupport(rowIndex, columnIndex)) {
            if (row[columnIndex - 1] == targetNumber) {
              return columnIndex;
            }
          }
        }
      }
    }
    return null;
  }
}
