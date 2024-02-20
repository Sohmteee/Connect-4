import 'dart:math';

import 'package:connect4/classes/computer_player.dart';
import 'package:connect4/classes/player.dart';
import 'package:connect4/classes/position.dart';
import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/data.dart';
import 'package:connect4/dialogs/not_your_turn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

enum GameMode {
  singlePlayer,
  twoPlayersOffline,
  twoPlayersOnline,
  twoPlayersBluetooth,
}

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.gameMode,
  });

  final GameMode gameMode;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final player1 = Player(1, name: 'You');
  final player2 = ComputerPlayer(2, humanPlayerNumber: 1, name: 'Nora');
  int? winner;
  late Player currentPlayer;
  bool isGameOver = false;
  bool canTap = true;
  bool isComputerPlaying = false;
  bool isAutoPlaying = false;
  PositionsList winningPositions = PositionsList([]);
  late Player firstPlayer;
  int? tappedIndex;
  List<int>? hints = [];

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

  makeMove(int columnIndex) {
    if (hints != null) {
      setState(() {
        hints = null;
      });
    }
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

  reset() async {
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

      currentPlayer = firstPlayer;
      player2.lastPlayedPosition = null;
      isGameOver = false;
      canTap = true;
      isComputerPlaying = false;
      winningPositions.clear();
      hints = null;
      winner = null;
    });

    if (currentPlayer == player2) {
      setState(() {
        isComputerPlaying = true;
      });
      int computerMove = await player2.play();

      makeMove(computerMove);
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

  @override
  void initState() {
    super.initState();
    firstPlayer = player1;
    currentPlayer = firstPlayer;
    reset();
  }

  @override
  Widget build(BuildContext context) {
    Color? turnColor = currentPlayer.number == 1 ? Colors.red : Colors.yellow;
    List<Color> turnColors = currentPlayer.number == 1
        ? [Colors.red[400]!, Colors.red[700]!]
        : [Colors.yellow[400]!, Colors.yellow[700]!];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(flex: 2),
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
                      fontSize: 12.sp,
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
                    fontSize: 14.sp,
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
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),
            ],
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
                  gradient: LinearGradient(
                    colors: turnColors,
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              winner == null
                  ? Text(
                      '${currentPlayer == player1 ? 'Your' : '${currentPlayer.name}\'s'} Turn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    )
                  : Text(
                      switch (winner) {
                        0 => 'It\'s a tie!',
                        1 => 'You won!',
                        2 => '${player2.name} won!',
                        _ => '',
                      },
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
          const Spacer(flex: 2),
          Row(
            children: [
              const Spacer(flex: 3),
              ZoomTapAnimation(
                onTap: () async {
                  try {
                    setState(() {
                      isAutoPlaying = true;
                    });

                    while (!isGameOver) {
                      if (canTap) {
                        List<int>? options = await player1.getHints();
                        int move = options!.length == 1
                            ? options[0]
                            : options[Random().nextInt(options.length)];
                        makeMove(move);
                      }
                    }
                  } catch (e) {
                    List freeColumns = gameBoard.where((row) {
                      return row.any((disc) => disc == 0);
                    }).map((row) {
                      return row.indexOf(0);
                    }).toList();

                    makeMove(freeColumns[Random().nextInt(freeColumns.length)]);

                    setState(() {
                      isAutoPlaying = false;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400]!,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: Colors.white,
                      width: 2.sp,
                    ),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              ZoomTapAnimation(
                onTap: () async {
                  hints = await player1.getHints();
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400]!,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: Colors.white,
                      width: 2.sp,
                    ),
                  ),
                  child: const Icon(
                    Icons.lightbulb_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              ZoomTapAnimation(
                onTap: () {
                  reset();
                },
                child: Container(
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400]!,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: Colors.white,
                      width: 2.sp,
                    ),
                  ),
                  child: Icon(
                    Icons.restart_alt_rounded,
                    size: 25.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  Container buildBoard() {
    return Container(
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
                int findRowIndex() {
                  for (int rowIndex = 6; rowIndex >= 0; rowIndex--) {
                    if (gameBoard[rowIndex][columnIndex] == 0) {
                      return rowIndex;
                    }
                  }
                  return -1;
                }

                return hints != null &&
                        hints!.contains(columnIndex) &&
                        rowIndex == findRowIndex()
                    ? Container(
                        width: 35.w,
                        height: 35.w,
                        margin: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepPurple[700],
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 2.sp,
                          ),
                        ),
                      )
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .scaleXY(
                          curve: Curves.easeOutSine,
                          delay: 2.seconds,
                          duration: .2.seconds,
                          begin: 1,
                          end: .8,
                        )
                        .then()
                        .scaleXY(
                          curve: Curves.easeOutSine,
                          duration: .4.seconds,
                          begin: .8,
                          end: 1.2,
                        )
                        .then()
                        .scaleXY(
                          curve: Curves.bounceOut,
                          duration: .4.seconds,
                          begin: 1.2,
                          end: 1,
                        )
                    : Container(
                        width: 35.w,
                        height: 35.w,
                        margin: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepPurple[700],
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
                List<Color> colors = [];
                if (gameBoard[rowIndex][columnIndex] != 0) {
                  if (gameBoard[rowIndex][columnIndex] == 1) {
                    color = Colors.red;
                    colors = [Colors.red[400]!, Colors.red[700]!];
                  } else if (gameBoard[rowIndex][columnIndex] == 2) {
                    color = Colors.yellow;
                    colors = [Colors.yellow[400]!, Colors.yellow[700]!];
                  }
                }
                return gameBoard[rowIndex][columnIndex] == 0
                    ? Container(
                        width: 35.w,
                        height: 35.w,
                        margin: EdgeInsets.all(5.w),
                      ).animate().scaleXY(
                          end: .87,
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
                              gradient: LinearGradient(
                                colors: colors,
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              ),
                              border: Border.all(
                                color: Colors.white,
                                width: 3.sp,
                              ),
                            ),
                          )
                            .animate()
                            .scaleXY(
                              curve: Curves.easeOutSine,
                              delay: (rowIndex * 100 + 200).milliseconds,
                              duration: .2.seconds,
                              begin: 1,
                              end: .8,
                            )
                            .then()
                            .scaleXY(
                              curve: Curves.easeOutSine,
                              duration: .4.seconds,
                              begin: .8,
                              end: 1.2,
                            )
                            .then()
                            .scaleXY(
                              curve: Curves.bounceOut,
                              duration: .4.seconds,
                              begin: 1.2,
                              end: 1,
                            )
                        : Container(
                            width: 35.w,
                            height: 35.w,
                            margin: EdgeInsets.all(5.w),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: colors,
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              ),
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
                              end: .87,
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
              if (gameBoard[rowIndex][columnIndex] == 0) {
                return rowIndex;
              }
            }
            return 0;
          }

          bool canDropInColumn() => List.generate(
                7,
                (rowIndex) => gameBoard[rowIndex][columnIndex],
              ).contains(0);

          return GestureDetector(
            onTap: () async {
              if (!canTap && !isGameOver) {
                showNotYourTurnDialog(context);
              } else if (!isGameOver &&
                  canTap &&
                  !isComputerPlaying &&
                  canDropInColumn()) {
                setState(() {
                  canTap = false;
                });
                makeMove(columnIndex);
                if (!isGameOver) {
                  setState(() {
                    isComputerPlaying = true;
                  });
                  int computerMove = await player2.play();
                  makeMove(computerMove);
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
      winner = 0;
      restartGame();
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
          setState(() {
            winner = checkHorizontal()['winner'];
          });
          winner == 1 ? player1.score++ : player2.score++;
        });

        isGameOver = true;
        canTap = false;
        restartGame();
      } else if (checkVertical().isNotEmpty) {
        debugPrint('Player ${checkVertical()['winner']} wins!');
        Future.delayed((rowIndex * 100 + 200).milliseconds, () {
          highlightWinningPositions(
            checkVertical()['winner'],
            checkVertical()['positions'],
          );

          setState(() {
            winner = checkVertical()['winner'];
          });
          winner == 1 ? player1.score++ : player2.score++;
        });

        isGameOver = true;
        canTap = false;
        restartGame();
      } else if (checkDiagonal().isNotEmpty) {
        debugPrint('Player ${checkDiagonal()['winner']} wins!');
        Future.delayed((rowIndex * 100 + 200).milliseconds, () {
          highlightWinningPositions(
            checkDiagonal()['winner'],
            checkDiagonal()['positions'],
          );

          setState(() {
            winner = checkDiagonal()['winner'];
          });
          winner == 1 ? player1.score++ : player2.score++;
        });

        isGameOver = true;
        canTap = false;
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
      setState(() {
        firstPlayer = firstPlayer.number == player1.number ? player2 : player1;
        reset();
      });
    });
  }
}
