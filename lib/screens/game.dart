import 'package:connect4/classes/position.dart';
import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/data.dart';
import 'package:connect4/classes/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Player player = Player(PlayerColor.red);
  bool canPlay = true;
  PositionsList winningPositions = PositionsList([]);

  makeMove(int columnIndex) {
    for (int i = 5; i >= 0; i--) {
      if (gameBoard[i][columnIndex] == 0) {
        setState(() {
          gameBoard[i][columnIndex] = player.color == PlayerColor.red ? 1 : 2;
          player.color = player.color == PlayerColor.red
              ? PlayerColor.yellow
              : PlayerColor.red;
        });
        break;
      }
    }
    checkWin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              // height: (30 * (6 + 2)).w,
              // width: (30 * (7 + 2)).w,
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  6,
                  (rowIndex) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      7,
                      (columnIndex) {
                        Color? color;
                        if (gameBoard[rowIndex][columnIndex] != 0) {
                          if (gameBoard[rowIndex][columnIndex] == 1) {
                            color = Colors.red;
                          } else if (gameBoard[rowIndex][columnIndex] == 2) {
                            color = Colors.yellow;
                          }
                        }
                        return GestureDetector(
                          onTap: () {
                            if (canPlay) {
                              makeMove(columnIndex);
                            }
                          },
                          child: (winningPositions
                                  .contains(Position(rowIndex, columnIndex)))
                              ? Container(
                                  width: 35.w,
                                  height: 35.w,
                                  margin: EdgeInsets.all(5.w),
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    gradient:
                                        gameBoard[rowIndex][columnIndex] == 0
                                            ? LinearGradient(
                                                colors: [
                                                  Colors.deepPurple[400]!,
                                                  backgroundColor!,
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              )
                                            : null,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3.sp,
                                    ),
                                  ),
                                ).animate().scaleXY(
                                    begin: 1,
                                    end: 1.2,
                                    duration: 500.milliseconds,
                                    delay: 300.milliseconds,
                                  )
                              : Container(
                                  width: 35.w,
                                  height: 35.w,
                                  margin: EdgeInsets.all(5.w),
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    gradient:
                                        gameBoard[rowIndex][columnIndex] == 0
                                            ? LinearGradient(
                                                colors: [
                                                  Colors.deepPurple[400]!,
                                                  backgroundColor!,
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              )
                                            : null,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  highlightWinningPositions(int winner, PositionsList positions) {
    setState(() {
      winningPositions = positions;
      debugPrint('Winning Positions: $winningPositions');
    });
  }

  checkWin() {
    setState(() {
      if (checkHorizontal().isNotEmpty) {
        debugPrint('Player ${checkHorizontal()['winner']} wins!');
        highlightWinningPositions(
          checkHorizontal()['winner'],
          checkHorizontal()['positions'],
        );
        canPlay = false;
      } else if (checkVertical().isNotEmpty) {
        debugPrint('Player ${checkVertical()['winner']} wins!');
        highlightWinningPositions(
          checkVertical()['winner'],
          checkVertical()['positions'],
        );
        canPlay = false;
      } else if (checkDiagonal().isNotEmpty) {
        debugPrint('Player ${checkDiagonal()['winner']} wins!');
        highlightWinningPositions(
          checkDiagonal()['winner'],
          checkDiagonal()['positions'],
        );
        canPlay = false;
      }
    });
  }

  Map<String, dynamic> checkHorizontal() {
    for (int rowIndex = 5; rowIndex >= 0; rowIndex--) {
      List row = gameBoard[rowIndex];
      int currentPlayerInt = 1;
      PositionsList positions = PositionsList([]);

      for (int columnIndex = 0; columnIndex < 7; columnIndex++) {
        if (row[columnIndex] == 0) {
          positions.clear();
          continue;
        }

        if (row[columnIndex] == currentPlayerInt) {
          positions.add(Position(rowIndex, columnIndex));
          if (positions.size() == 4) {
            return {
              'winner': currentPlayerInt,
              'positions': positions,
            };
          }
        } else {
          positions.clear();
          positions.add(Position(rowIndex, columnIndex));
          currentPlayerInt = row[columnIndex];
        }
      }
    }
    return {};
  }

  Map<String, dynamic> checkVertical() {
    for (int columnIndex = 0; columnIndex < 6; columnIndex++) {
      List column = List.generate(
        6,
        (rowIndex) => gameBoard[rowIndex][columnIndex],
      );
      int currentPlayerInt = 1;
      PositionsList positions = PositionsList([]);

      for (int rowIndex = 5; rowIndex >= 0; rowIndex--) {
        if (column[rowIndex] == 0) {
          positions.clear();
          break;
        }

        if (column[rowIndex] == currentPlayerInt) {
          positions.add(Position(rowIndex, columnIndex));
          if (positions.size() == 4) {
            return {
              'winner': currentPlayerInt,
              'positions': positions,
            };
          }
        } else {
          positions.clear();
          positions.add(Position(rowIndex, columnIndex));
          currentPlayerInt = column[rowIndex];
        }
      }
    }
    return {};
  }

  Map<String, dynamic> checkDiagonal() {
    // Check diagonals from bottom-left to top-right
    for (int rowIndex = 3; rowIndex < 6; rowIndex++) {
      for (int columnIndex = 0; columnIndex < 4; columnIndex++) {
        PositionsList positions = PositionsList([]);
        int currentPlayerInt = 0;

        for (int i = 0; i < 4; i++) {
          int row = rowIndex - i;
          int col = columnIndex + i;

          if (gameBoard[row][col] == 0) {
            positions.clear();
            break;
          }

          if (currentPlayerInt == 0) {
            currentPlayerInt = gameBoard[row][col];
          }

          if (gameBoard[row][col] == currentPlayerInt) {
            positions.add(Position(row, col));
            if (positions.size() == 4) {
              return {
                'winner': currentPlayerInt,
                'positions': positions,
              };
            }
          } else {
            positions.clear();
            positions.add(Position(row, col));
            currentPlayerInt = gameBoard[row][col];
          }
        }
      }
    }

    // Check diagonals from bottom-right to top-left
    for (int rowIndex = 3; rowIndex < 6; rowIndex++) {
      for (int columnIndex = 6; columnIndex >= 3; columnIndex--) {
        PositionsList positions = PositionsList([]);
        int currentPlayerInt = 0;

        for (int i = 0; i < 4; i++) {
          int row = rowIndex - i;
          int col = columnIndex - i;

          if (gameBoard[row][col] == 0) {
            positions.clear();
            break;
          }

          if (currentPlayerInt == 0) {
            currentPlayerInt = gameBoard[row][col];
          }

          if (gameBoard[row][col] == currentPlayerInt) {
            positions.add(Position(row, col));
            if (positions.size() == 4) {
              return {
                'winner': currentPlayerInt,
                'positions': positions,
              };
            }
          } else {
            positions.clear();
            positions.add(Position(row, col));
            currentPlayerInt = gameBoard[row][col];
          }
        }
      }
    }

    return {};
  }
}
