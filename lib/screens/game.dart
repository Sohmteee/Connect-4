import 'package:connect4/classes/computer_player.dart';
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
  final player1 = Player(1, name: 'You');
  final player2 = ComputerPlayer(2, humanPlayerNumber: 1, name: 'Alex');
  late Player currentPlayer;
  bool isGameOver = true;
  bool isComputerPlaying = false;
  PositionsList winningPositions = PositionsList([]);
  late Player firstPlayer;

  alternatePlayer() {
    currentPlayer = currentPlayer.number == 1 ? player2 : player1;
  }

  List<List<int>> stringToBoard(String string) {
    return List.generate(7, (rowIndex) {
      return List.generate(7, (columnIndex) {
        return int.parse(string[rowIndex * 7 + columnIndex]);
      });
    });
  }

  makeMove(int columnIndex) {
    for (int rowIndex = 6; rowIndex >= 0; rowIndex--) {
      if (gameBoard[rowIndex][columnIndex] == 0) {
        setState(() {
          gameBoard[rowIndex][columnIndex] = currentPlayer.number;

          // if it was the computer's move, register the new last played position
          if (currentPlayer.number == player2.number) {
            player2.lastPlayedPosition = Position(rowIndex, columnIndex);
          }
          alternatePlayer();
        });
        break;
      }
    }

    checkWin();
    checkTie();
  }

  reset() {
    setState(() {
      gameBoard = [
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
      ];
      currentPlayer = Player(1);
      player2.lastPlayedPosition = null;
      isGameOver = true;
      isComputerPlaying = false;
      winningPositions.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    firstPlayer = player1;
    currentPlayer = firstPlayer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Row(
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/computer.png',
                          height: 40.h,
                          width: 40.w,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          player2.name!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${player2.score} - ${player1.score}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/player.png',
                          height: 40.h,
                          width: 40.w,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          player1.name!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    reset();
                  },
                  icon: const Icon(Icons.restart_alt_rounded),
                  color: Colors.white,
                  iconSize: 30.sp,
                ),
              ],
            ),
          ),
          const Spacer(flex: 5),
          Center(
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(2.5.w),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      7,
                      (rowIndex) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          7,
                          (columnIndex) {
                            return GestureDetector(
                              onTap: () async {
                                if (isGameOver && !isComputerPlaying) {
                                  makeMove(columnIndex);
                                  if (isGameOver) {
                                    setState(() {
                                      isComputerPlaying = true;
                                    });
                                    int computerMove = await player2.play();
                                    makeMove(computerMove);
                                    setState(() {
                                      isComputerPlaying = false;
                                    });
                                  }
                                }
                              },
                              child: Container(
                                width: 35.w,
                                height: 35.w,
                                margin: EdgeInsets.all(5.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.deepPurple[400]!,
                                      backgroundColor!,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(2.5.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      7,
                      (rowIndex) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          7,
                          (columnIndex) {
                            Color? color;
                            if (gameBoard[rowIndex][columnIndex] != 0) {
                              if (gameBoard[rowIndex][columnIndex] == 1) {
                                color = Colors.red;
                              } else if (gameBoard[rowIndex][columnIndex] ==
                                  2) {
                                color = Colors.yellow;
                              }
                            }
                            return GestureDetector(
                                onTap: () async {
                                  if (isGameOver && !isComputerPlaying) {
                                    makeMove(columnIndex);
                                    if (isGameOver) {
                                      setState(() {
                                        isComputerPlaying = true;
                                      });
                                      int computerMove = await player2.play();
                                      makeMove(computerMove);
                                      setState(() {
                                        isComputerPlaying = false;
                                      });
                                    }
                                  }
                                },
                                child: (winningPositions.contains(
                                        Position(rowIndex, columnIndex)))
                                    ? Container(
                                        width: 35.w,
                                        height: 35.w,
                                        margin: EdgeInsets.all(5.w),
                                        decoration: BoxDecoration(
                                          color: color,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3.sp,
                                          ),
                                        ),
                                      )
                                        .animate()
                                        .scaleXY(
                                          begin: 1,
                                          end: 1.2,
                                          duration: 500.milliseconds,
                                          delay: 100.milliseconds,
                                          curve: Curves.easeInOutQuart,
                                        )
                                        .then()
                                        .scaleXY(
                                          begin: 1,
                                          end: .833333333333333333,
                                          duration: 300.milliseconds,
                                          delay: 500.milliseconds,
                                          curve: Curves.bounceOut,
                                        )
                                    : Container(
                                        width: 35.w,
                                        height: 35.w,
                                        margin: EdgeInsets.all(5.w),
                                        decoration: BoxDecoration(
                                          color: color,
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                        .animate()
                                        .moveY(
                                          begin: -((35 * (7 + 2.5))).h,
                                          end: 0,
                                          duration: (rowIndex * 100 + 100)
                                              .milliseconds,
                                          delay: 100.milliseconds,
                                          curve: Curves.bounceOut,
                                        )
                                        .scaleXY(
                                          end: .85,
                                          duration: 300.milliseconds,
                                          curve: Curves.bounceOut,
                                        ));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 7),
        ],
      ),
    );
  }

  void highlightWinningPositions(int winner, PositionsList positions) {
    setState(() {
      winningPositions = positions;
      debugPrint('Winning Positions: $winningPositions');
    });
  }

  void checkTie() {
    if (gameBoard.every((row) => row.every((cell) => cell != 0))) {
      debugPrint('Tie!');
      isGameOver = false;
      restartGame();
    }
  }

  void checkWin() {
    setState(() {
      if (checkHorizontal().isNotEmpty) {
        debugPrint('Player ${checkHorizontal()['winner']} wins!');
        highlightWinningPositions(
          checkHorizontal()['winner'],
          checkHorizontal()['positions'],
        );
        isGameOver = false;
        restartGame();
      } else if (checkVertical().isNotEmpty) {
        debugPrint('Player ${checkVertical()['winner']} wins!');
        highlightWinningPositions(
          checkVertical()['winner'],
          checkVertical()['positions'],
        );
        isGameOver = false;
        restartGame();
      } else if (checkDiagonal().isNotEmpty) {
        debugPrint('Player ${checkDiagonal()['winner']} wins!');
        highlightWinningPositions(
          checkDiagonal()['winner'],
          checkDiagonal()['positions'],
        );
        isGameOver = false;
        restartGame();
      }
    });
  }

  Map<String, dynamic> checkHorizontal() {
    for (int rowIndex = 6; rowIndex >= 0; rowIndex--) {
      List row = gameBoard[rowIndex];
      int currentPlayerInt = 1;
      PositionsList positions = PositionsList([]);

      for (int columnIndex = 0; columnIndex < 7; columnIndex++) {
        if (row[columnIndex] == 0) {
          if (positions.size() >= 4) {
            return {
              'winner': currentPlayerInt,
              'positions': positions,
            };
          } else {
            positions.clear();
            continue;
          }
        }

        if (row[columnIndex] == currentPlayerInt) {
          positions.add(Position(rowIndex, columnIndex));
          if (positions.size() >= 4) {
            if (columnIndex != 6) {
              if (row[columnIndex + 1] == currentPlayerInt) {
                continue;
              }
            }
            return {
              'winner': currentPlayerInt,
              'positions': positions,
            };
          }
        } else {
          if (positions.size() >= 4) {
            return {
              'winner': currentPlayerInt,
              'positions': positions,
            };
          } else {
            positions.clear();
            positions.add(Position(rowIndex, columnIndex));
            currentPlayerInt = row[columnIndex];
          }
        }
      }
    }
    return {};
  }

  Map<String, dynamic> checkVertical() {
    for (int columnIndex = 0; columnIndex < 7; columnIndex++) {
      List column = List.generate(
        7,
        (rowIndex) => gameBoard[rowIndex][columnIndex],
      );
      int currentPlayerInt = 1;
      PositionsList positions = PositionsList([]);

      for (int rowIndex = 6; rowIndex >= 0; rowIndex--) {
        if (column[rowIndex] == 0) {
          if (positions.size() >= 4) {
            return {
              'winner': currentPlayerInt,
              'positions': positions,
            };
          } else {
            positions.clear();
            break;
          }
        }

        if (column[rowIndex] == currentPlayerInt) {
          positions.add(Position(rowIndex, columnIndex));
        } else {
          if (positions.size() >= 4) {
            return {
              'winner': currentPlayerInt,
              'positions': positions,
            };
          } else {
            positions.clear();
            positions.add(Position(rowIndex, columnIndex));
            currentPlayerInt = column[rowIndex];
          }
        }
      }
      if (positions.size() >= 4) {
        return {
          'winner': currentPlayerInt,
          'positions': positions,
        };
      }
    }
    return {};
  }

  Map<String, dynamic> checkDiagonal() {
    // Check diagonals from bottom-left to top-right
    for (int rowIndex = 3; rowIndex < 7; rowIndex++) {
      for (int columnIndex = 0; columnIndex < 4; columnIndex++) {
        PositionsList positions = PositionsList([]);
        int currentPlayerInt = 0;

        for (int i = 0; i < 4; i++) {
          int row = rowIndex - i;
          int col = columnIndex + i;

          if (row < 0 ||
              row >= 7 ||
              col < 0 ||
              col >= 7 ||
              gameBoard[row][col] == 0) {
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
    for (int rowIndex = 3; rowIndex < 7; rowIndex++) {
      for (int columnIndex = 6; columnIndex >= 3; columnIndex--) {
        PositionsList positions = PositionsList([]);
        int currentPlayerInt = 0;

        for (int i = 0; i < 4; i++) {
          int row = rowIndex - i;
          int col = columnIndex - i;

          if (row < 0 ||
              row >= 7 ||
              col < 0 ||
              col >= 7 ||
              gameBoard[row][col] == 0) {
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

  restartGame() {
    Future.delayed(3.seconds, () async {
      reset();

      setState(() {
        firstPlayer = firstPlayer.number == player1.number ? player2 : player1;
        currentPlayer = firstPlayer;
      });

      if (currentPlayer == player2) {
        setState(() {
          isComputerPlaying = true;
        });
        int computerMove = await player2.play();
        makeMove(computerMove);
        setState(() {
          isComputerPlaying = false;
        });
      }
    });
  }
}
