import 'dart:convert';
import 'dart:math';

import 'package:connect4/classes/player.dart';
import 'package:connect4/classes/position.dart';
import 'package:connect4/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ComputerPlayer extends Player {
  Position? lastPlayedPosition;
  int humanPlayerNumber;
  ComputerPlayer(
    super.number, {
    required this.humanPlayerNumber,
    super.name,
  });

  Future<int> play() async {
    var client = http.Client();
    try {
      var response = await client.post(
          Uri.https('kevinalbs.com', 'connect4/back-end/index.php/getMoves'),
          body: {
            'board_data': boardToString(),
            'player': number.toString(),
          });

      Map<String, dynamic> moves = jsonDecode(response.body);
      debugPrint('Response body: $moves');

      // iterate through the map and find the largest value
      int max = moves['0'];
      List<int> maxIndexes = [];

      for (int move in moves.values) {
        if (move > max) {
          max = move;
          maxIndexes = [int.parse(moves.keys.first)];
        } else if (move == max) {
          maxIndexes.add(int.parse(moves.keys.first));
        }
      }

      maxIndexes = moves.entries
          .where((element) {
            int intValue = int.tryParse(element.value.toString()) ?? 0;
            return intValue == max;
          })
          .map((element) => int.parse(element.key))
          .toList();

      debugPrint('Max Index: $maxIndexes($max)');
      return maxIndexes.length == 1
          ? maxIndexes[0]
          : maxIndexes[Random().nextInt(maxIndexes.length)];
    } catch (e) {
      // return (play());
      debugPrint('Error: $e');
      debugPrint('Playing offline...');
      return offlinePlay();
    } finally {
      client.close();
    }
  }

  int offlinePlay() {
    // try to win horizontally
    if (completeHorizontalTriple(number) != null) {
      debugPrint(
          'Complete Horizontal Triple (${completeHorizontalTriple(number)})');
      return completeHorizontalTriple(number)!;
    }
    // try to block any win horizontally
    else if (completeHorizontalTriple(humanPlayerNumber) != null) {
      debugPrint(
          'Block Horizontal Triple (${completeHorizontalTriple(humanPlayerNumber)})');
      return completeHorizontalTriple(humanPlayerNumber)!;
    }

    // try to win vertically

    //try to block any win vertically

    // try to win diagonally

    // try to block any win diagonally

    // try to fill in an empty space horizontally
    if (fillEmptySpace(number) != null) {
      debugPrint('Filled Empty Space (${fillEmptySpace(number)})');
      return fillEmptySpace(number)!;
    } else if (fillEmptySpace(humanPlayerNumber) != null) {
      debugPrint('Filled Empty Space (${fillEmptySpace(humanPlayerNumber)})');
      return fillEmptySpace(humanPlayerNumber)!;
    }

    // try to complete a pair horizontally

    // try to complete a pair vertically

    // try to complete a pair diagonally

    // try to play next to the last played position horizontally, vertically or diagonally
    else if (playClosestHorizontal() != null ||
        playClosestVertical() != null ||
        playClosestDiagonal() != null) {
      return randomizeClosePlay()!;
    }

    // play random
    else {
      return playRandom();
    }
  }

  /// Method to check if the cell has support from the bottom
  bool hasSupport(int rowIndex, int columnIndex) {
    return (rowIndex == 6) ? true : gameBoard[rowIndex + 1][columnIndex] != 0;
  }

  int? randomizeClosePlay() {
    int? Function() fn1 = playClosestHorizontal;
    int? Function() fn2 = playClosestVertical;
    int? Function() fn3 = playClosestDiagonal;
    int random = Random().nextInt(3);
    debugPrint('Random: $random');
    switch (random) {
      case 0:
        debugPrint('Doing case 0');
        if (fn1() != null) {
          debugPrint('Played Closet Horizontal (${playClosestHorizontal()})');
          return fn1();
        }
        if (fn2() != null) {
          debugPrint('Played Closet Vertical (${playClosestVertical()})');
          return fn2();
        }
        if (fn3() != null) {
          debugPrint('Played Closet Diagonal (${playClosestDiagonal()})');
          return fn3();
        }
        return null;
      case 1:
        debugPrint('Doing case 1');
        if (fn2() != null) {
          debugPrint('Played Closet Vertical (${playClosestVertical()})');
          return fn2();
        }
        if (fn3() != null) {
          debugPrint('Played Closet Diagonal (${playClosestDiagonal()})');
          return fn3();
        }
        if (fn1() != null) {
          debugPrint('Played Closet Horizontal (${playClosestHorizontal()})');
          return fn1();
        }
        return null;
      case 2:
        debugPrint('Doing case 2');
        if (fn3() != null) {
          debugPrint('Played Closet Diagonal (${playClosestDiagonal()})');
          return fn3();
        }
        if (fn1() != null) {
          debugPrint('Played Closet Horizontal (${playClosestHorizontal()})');
          return fn1();
        }
        if (fn2() != null) {
          debugPrint('Played Closet Vertical (${playClosestVertical()})');
          return fn2();
        }
        return null;
    }
    return null;
  }

  int? completeHorizontalTriple(int targetNumber) {
    // getBoundaries(List row, int index) {}

    for (int rowIndex = 5; rowIndex >= 0; rowIndex--) {
      List row = gameBoard[rowIndex];

      // terminate if there's no disc in the row
      if (row.every((disc) => disc == 0)) break;

      // if there's no empty space to fill, move over to the next row
      if (!row.contains(0)) continue;

      for (int columnIndex = 0; columnIndex < 5; columnIndex++) {
        // check if the target number reccured thrice in the current row
        if (row[columnIndex] == targetNumber &&
            row[columnIndex + 1] == targetNumber &&
            row[columnIndex + 2] == targetNumber) {
          if (columnIndex >= 1 &&
              row[columnIndex - 1] == 0 &&
              hasSupport(rowIndex, columnIndex - 1) &&
              columnIndex <= 3 &&
              row[columnIndex + 3] == 0 &&
              hasSupport(rowIndex, columnIndex + 3)) {
            return Random().nextBool() ? columnIndex + 3 : columnIndex - 1;
          } else if (columnIndex <= 3 &&
              row[columnIndex + 3] == 0 &&
              hasSupport(rowIndex, columnIndex + 3)) {
            return columnIndex + 3;
          } else if (columnIndex >= 1 &&
              row[columnIndex - 1] == 0 &&
              hasSupport(rowIndex, columnIndex - 1)) {
            return columnIndex - 1;
          }
        }
      }
    }

    return null;
  }

  /// Method to place a disk into an empty space either between two disks of
  /// the target color or at the beginning/end of a row if the next disk
  /// has the target color.
  int? fillEmptySpace(int targetNumber) {
    for (int rowIndex = 5; rowIndex >= 0; rowIndex--) {
      List row = gameBoard[rowIndex];

      // terminate if there's no disc in the row
      if (row.every((disc) => disc == 0)) break;

      // if there's no empty space to fill, move over to the next row
      if (!row.contains(0)) continue;

      for (int columnIndex = 1; columnIndex < row.length - 1; columnIndex++) {
        if (row[columnIndex] == 0) {
          if ((columnIndex > 0 && columnIndex < row.length - 1) &&
              hasSupport(rowIndex, columnIndex)) {
            if (row[columnIndex - 1] == targetNumber &&
                row[columnIndex + 1] == targetNumber) {
              return columnIndex;
            }
          }
          /* if (columnIndex == row.length - 1 &&
              hasSupport(rowIndex, columnIndex)) {
            if (row[columnIndex - 1] == targetNumber) {
              return columnIndex;
            }
          } */
        }
      }
      /* if (hasSupport(rowIndex, 0)) {
        if (row[0 + 1] == targetNumber) {
          return 0;
        }
      } */
    }
    return null;
  }

  int? playClosestHorizontal() {
    if (lastPlayedPosition != null) {
      int columnIndex = lastPlayedPosition!.y;
      List row = gameBoard[lastPlayedPosition!.x];

      // extremes
      if (columnIndex == 0 &&
          row[columnIndex + 1] == 0 &&
          hasSupport(row[columnIndex + 1], columnIndex)) {
        return columnIndex + 1;
      } else if (columnIndex == 6 &&
          row[columnIndex - 1] == 0 &&
          hasSupport(row[columnIndex - 1], columnIndex)) {
        return columnIndex - 1;
      } else if (columnIndex > 0 && columnIndex < 6) {
        // it's neither in the first nor last column
        // randomize if both sides are empty
        if ((row[columnIndex - 1] == 0 &&
                hasSupport(lastPlayedPosition!.x, columnIndex - 1)) &&
            (row[columnIndex + 1] == 0 &&
                hasSupport(lastPlayedPosition!.x, columnIndex + 1))) {
          if (Random().nextBool()) {
            return columnIndex + 1;
          } else {
            return columnIndex - 1;
          }
        }
        // else fill the empty side
        else if (row[columnIndex - 1] == 0 &&
            hasSupport(lastPlayedPosition!.x, columnIndex - 1)) {
          return columnIndex - 1;
        } else if (row[columnIndex + 1] == 0 &&
            hasSupport(lastPlayedPosition!.x, columnIndex + 1)) {
          return columnIndex + 1;
        }
      }
    }
    return null;
  }

  int? playClosestVertical() {
    if (lastPlayedPosition != null) {
      int columnIndex = lastPlayedPosition!.y;
      List column = gameBoard.map((row) => row[columnIndex]).toList();

      int? findTopmostDisc(List column) {
        for (int i = 0; i < column.length; i++) {
          if (column[i] != 0) {
            return column[i];
          }
        }
        return null;
      }

      if (column.contains(0) && findTopmostDisc(column) == number) {
        return columnIndex;
      }
    }
    return null;
  }

  int? playClosestDiagonal() {
    if (lastPlayedPosition != null) {
      int columnIndex = lastPlayedPosition!.y;
      int rowIndex = lastPlayedPosition!.x;

      // if there's a row above, try to play diagonally
      if (rowIndex > 0) {
        List topRow = gameBoard[rowIndex - 1];

        // if there's a column to the left and right...
        if (columnIndex > 0 && columnIndex < 6) {
          // if both are empty, randomly play diagonally
          if (topRow[columnIndex - 1] == 0 &&
              hasSupport(rowIndex - 1, columnIndex - 1) &&
              topRow[columnIndex + 1] == 0 &&
              hasSupport(rowIndex - 1, columnIndex + 1)) {
            if (Random().nextBool()) {
              return columnIndex + 1;
            } else {
              return columnIndex - 1;
            }
          }
          // else fill the empty side
          else if (topRow[columnIndex + 1] == 0 &&
              hasSupport(rowIndex - 1, columnIndex + 1)) {
            return columnIndex + 1;
          } else if (topRow[columnIndex - 1] == 0 &&
              hasSupport(rowIndex - 1, columnIndex - 1)) {
            return columnIndex - 1;
          }
        }
        // else if there's a column to the right alone, fill it up
        else if (columnIndex == 0 &&
            topRow[columnIndex + 1] == 0 &&
            hasSupport(rowIndex - 1, columnIndex + 1)) {
          return columnIndex + 1;
        }
        // else if there's a column to the left alone, fill it up
        else if (columnIndex == 6 &&
            topRow[columnIndex - 1] == 0 &&
            hasSupport(rowIndex - 1, columnIndex - 1)) {
          return columnIndex - 1;
        }
      }
    }
    return null;
  }

  int playRandom() {
    int columnIndex = Random().nextInt(7);
    List column = List.generate(
      7,
      (rowIndex) => gameBoard[rowIndex][columnIndex],
    );

    while (column.every((disc) => disc != 0)) {
      columnIndex = Random().nextInt(7);
      column = List.generate(
        7,
        (rowIndex) => gameBoard[rowIndex][columnIndex],
      );
    }

    debugPrint('Played Randomly');
    return columnIndex;
  }
}
