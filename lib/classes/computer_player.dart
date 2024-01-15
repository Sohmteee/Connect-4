import 'package:connect4/classes/player.dart';
import 'package:connect4/data.dart';

class ComputerPlayer extends Player {
  ComputerPlayer(super.number);

  void play() {}

  /// Method to check if the cell has support from the bottom
  bool hasSupport(int rowIndex, int columnIndex) {
    return (rowIndex == 5) ? true : gameBoard[rowIndex + 1][columnIndex] != 0;
  }

  void completeHorizontalThree( int targetNumber) {
    /// Method to place a disk into an empty space either between two disks of
    /// the target color or at the beginning/end of a row if the next disk
    /// has the target color.
    int? fillEmptySpace(List row, int rowIndex) {
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
      return null;
    }

    if (fillEmptySpace(row, rowIndex) != null) {
      // place disk
    }
  }
}
