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
  final player2 = ComputerPlayer(2, humanPlayerNumber: 1, name: 'Nora');
  late Player currentPlayer;
  bool isGameOver = false;
  bool canTap = true;
  bool isComputerPlaying = false;
  PositionsList winningPositions = PositionsList([]);
  late Player firstPlayer;
  int? tappedIndex;

  alternatePlayer() {
    if (!isGameOver) {
      currentPlayer = currentPlayer.number == 1 ? player2 : player1;
    }
  }

  List<List<int>> stringToBoard(String string) {
    return List.generate(7, (rowIndex) {
      return List.generate(7, (columnIndex) {
        return int.parse(string[rowIndex * 7 + columnIndex]);
      });
    });
  }

  makeMove(int rowIndex, int columnIndex) {
    for (int rowIndex = 6; rowIndex >= 0; rowIndex--) {
      if (gameBoard[rowIndex][columnIndex] == 0) {
        setState(() {
          gameBoard[rowIndex][columnIndex] = currentPlayer.number;

          // if it was the computer's move, register the new last played position
          if (currentPlayer.number == player2.number) {
            player2.lastPlayedPosition = Position(rowIndex, columnIndex);
          }
          alternatePlayer();
          checkWin(rowIndex);
          checkTie(rowIndex);
        });
        break;
      }
    }
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
      // firstPlayer = player1;
      // currentPlayer = firstPlayer;
      player2.lastPlayedPosition = null;
      isGameOver = false;
      canTap = true;
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
    Color? turnColor = currentPlayer.number == 1 ? Colors.red : Colors.yellow;

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Column(
        children: [
          const Spacer(flex: 2),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 90.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
                  child: Text(
                    '${player2.score} - ${player1.score}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
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
          ),
          const Spacer(flex: 2),
          Row(
            children: [
              const Spacer(flex: 5),
              Container(
                width: 25.w,
                height: 25.w,
                margin: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: turnColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                '${currentPlayer == player1 ? 'Your' : '${currentPlayer.name}\'s'} Turn',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
              const Spacer(flex: 6),
            ],
          ),
          const Spacer(flex: 2),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                buildBoard(),
                buildDiscs(),
                buildTapHighlight(),
              ],
            ),
          ),
          const Spacer(flex: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  reset();
                },
                icon: const Icon(Icons.restart_alt_rounded),
                color: Colors.white,
                iconSize: 25.sp,
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Container buildBoard() {
    return Container(
      padding: EdgeInsets.all(2.5.w),
      decoration: BoxDecoration(
        color: backgroundColor,
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
                return Container(
                  width: 35.w,
                  height: 35.w,
                  margin: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        backgroundColor!,
                        Colors.deepPurple[400]!,
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Padding buildDiscs() {
    return Padding(
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
                  } else if (gameBoard[rowIndex][columnIndex] == 2) {
                    color = Colors.yellow;
                  }
                }
                return gameBoard[rowIndex][columnIndex] == 0
                    ? Container(
                        width: 35.w,
                        height: 35.w,
                        margin: EdgeInsets.all(5.w),
                      ).animate().scaleXY(
                          end: .85,
                          duration: 300.milliseconds,
                          curve: Curves.bounceOut,
                        )
                    : (winningPositions
                            .contains(Position(rowIndex, columnIndex)))
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
                              duration: 300.milliseconds,
                              delay: (rowIndex * 100 + 200).milliseconds,
                              curve: Curves.easeIn,
                            )
                            .then()
                            .scaleXY(
                              begin: 1,
                              end: .833333333333333333,
                              duration: 300.milliseconds,
                              delay: 300.milliseconds,
                              curve: Curves.easeOut,
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
                              begin: -((35 * (rowIndex + 2))).w,
                              end: 0,
                              duration: (rowIndex * 100 + 100).milliseconds,
                              delay: 100.milliseconds,
                              curve: Curves.bounceOut,
                            )
                            .scaleXY(
                              end: .85,
                              duration: 300.milliseconds,
                              curve: Curves.bounceOut,
                            );
              },
            ),
          ),
        ),
      ),
    );
  }

  Row buildTapHighlight() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        7,
        (columnIndex) {
          int findRowIndex() {
            for (int rowIndex = 6; rowIndex >= 0; rowIndex--) {
              if (gameBoard[rowIndex][columnIndex] != 0) {
                return rowIndex;
              }
            }
            return 0;
          }

          bool canDropInColumn() => List.generate(
                7,
                (rowIndex) => gameBoard[rowIndex][columnIndex],
              ).contains(0);

          int rowIndex = findRowIndex();

          return GestureDetector(
            onTap: () async {
              if (!isGameOver &&
                  canTap &&
                  !isComputerPlaying &&
                  canDropInColumn()) {
                setState(() {
                  canTap = false;
                });
                makeMove(rowIndex, columnIndex);
                if (!isGameOver) {
                  setState(() {
                    isComputerPlaying = true;
                  });
                  int computerMove = await player2.play();
                  makeMove(rowIndex, computerMove);
                  setState(() {
                    isComputerPlaying = false;
                    Future.delayed(300.milliseconds, () {
                      setState(() {
                        canTap = true;
                      });
                    });
                  });
                }
              }
            },
            onTapDown: (details) {
              setState(() {
                tappedIndex = columnIndex;
              });
            },
            onTapUp: (details) {
              setState(() {
                tappedIndex = null;
              });
            },
            onTapCancel: () {
              setState(() {
                tappedIndex = null;
              });
            },
            child: AnimatedContainer(
              duration: 200.milliseconds,
              height: (((35 + 10) * 7)).w,
              width: (35 + 10 + (5 / 7)).w,
              decoration: BoxDecoration(
                color: (tappedIndex != null && columnIndex == tappedIndex)
                    ? Colors.white.withOpacity(.3)
                    : Colors.transparent,
                // color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.sp),
              ),
            ),
          );
        },
      ),
    );
  }

  void highlightWinningPositions(int winner, PositionsList positions) {
    setState(() {
      winningPositions = positions;
      debugPrint('Winning Positions: $winningPositions');
    });
  }

  void checkTie(int rowIndex) {
    if (gameBoard.every((row) => row.every((cell) => cell != 0))) {
      debugPrint('Tie!');
      isGameOver = true;
      canTap = false;
      restartGame(rowIndex);
    }
  }

  void checkWin(int rowIndex) {
    setState(() {
      if (checkHorizontal().isNotEmpty) {
        debugPrint('Player ${checkHorizontal()['winner']} wins!');
        Future.delayed((rowIndex * 100 + 200).milliseconds, () {
          highlightWinningPositions(
            checkHorizontal()['winner'],
            checkHorizontal()['positions'],
          );
          checkHorizontal()['winner'] == 1 ? player1.score++ : player2.score++;
        });

        isGameOver = true;
        canTap = false;
        restartGame(rowIndex);
      } else if (checkVertical().isNotEmpty) {
        debugPrint('Player ${checkVertical()['winner']} wins!');
        Future.delayed((rowIndex * 100 + 200).milliseconds, () {
          highlightWinningPositions(
            checkVertical()['winner'],
            checkVertical()['positions'],
          );
          checkVertical()['winner'] == 1 ? player1.score++ : player2.score++;
        });

        isGameOver = true;
        canTap = false;
        restartGame(rowIndex);
      } else if (checkDiagonal().isNotEmpty) {
        debugPrint('Player ${checkDiagonal()['winner']} wins!');
        Future.delayed((rowIndex * 100 + 200).milliseconds, () {
          highlightWinningPositions(
            checkDiagonal()['winner'],
            checkDiagonal()['positions'],
          );
          checkDiagonal()['winner'] == 1 ? player1.score++ : player2.score++;
        });

        isGameOver = true;
        canTap = false;
        restartGame(rowIndex);
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

  restartGame(int rowIndex) {
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
        makeMove(rowIndex, computerMove);
        setState(() {
          isComputerPlaying = false;
        });
      }
    });
  }
}
