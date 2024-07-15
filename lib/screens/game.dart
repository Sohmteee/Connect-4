import 'dart:async';
import 'dart:math';

// import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:back_pressed/back_pressed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect4/classes/computer_player.dart';
import 'package:connect4/classes/player.dart';
import 'package:connect4/classes/position.dart';
import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/data.dart';
import 'package:connect4/dialogs/not_your_turn.dart';
import 'package:connect4/screens/rooms/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../widgets/neon_circular_timer/neon_circular_timer.dart';

enum GameMode {
  twoPlayersOffline,
  twoPlayersOnline,
  twoPlayersBluetooth,
}

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    this.gameMode = GameMode.twoPlayersOnline,
    required this.player1,
    required this.player2,
  });

  final GameMode gameMode;
  final Player player1;
  final Player player2;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

final gameRoom = privateRooms.doc(roomName.text);

class _GameScreenState extends State<GameScreen> {
  String? winner;
  late Player currentPlayer;
  bool isGameOver = false;
  bool canTap = true;
  bool isPlayer2Playing = false;
  bool isAutoPlaying = false;
  bool canExit = false;
  PositionsList winningPositions = PositionsList([]);
  late Player firstPlayer;
  int? tappedIndex;
  List<int>? hints = [];

  final countDownController = CountDownController();
  bool answered = false;
  bool hasStartedCountDown = false;

  // late Stream<DocumentSnapshot> boardStream;

  List flattenGameBoard(List board) {
    return board.expand((row) => row).toList();
  }

  List<List<int>> unflattenGameBoard(List<int> flattenedBoard) {
    List<List<int>> board = [];
    for (int i = 0; i < 7; i++) {
      board.add(flattenedBoard.sublist(i * 7, (i + 1) * 7));
    }
    return board;
  }

  void initializeServerParameters() async {
    await gameRoom.set(
      {
        'gameBoard': flattenGameBoard(gameBoard),
        'winner': winner,
        'currentPlayerNumber': currentPlayer.number,
        'isGameOver': isGameOver,
      },
      SetOptions(merge: true),
    );
  }

  alternatePlayer() async {
    if (!isGameOver) {
      currentPlayer =
          currentPlayer.number == 1 ? widget.player2 : widget.player1;
      isPlayer2Playing = !isPlayer2Playing;
      await gameRoom.update({
        'currentPlayerNumber': currentPlayer.number,
      });
    }
  }

  List<List<int>> stringToBoard(String string) {
    return List.generate(7, (rowIndex) {
      return List.generate(7, (columnIndex) {
        return int.parse(string[rowIndex * 7 + columnIndex]);
      });
    });
  }

  makeMove(int columnIndex) async {
    countDownController.pause();
    if (hints != null) {
      setState(() {
        hints = null;
      });
    }
    for (int rowIndex = 6; rowIndex >= 0; rowIndex--) {
      if (gameBoard[rowIndex][columnIndex] == 0) {
        setState(() {
          gameBoard[rowIndex][columnIndex] = currentPlayer.number;
        });
        await gameRoom.update({
          'gameBoard': flattenGameBoard(gameBoard),
        });
        alternatePlayer();
        checkWin(rowIndex);
        checkTie(rowIndex);

        if (!isGameOver) {
          countDownController.start();
        }

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

      currentPlayer = firstPlayer;
      if (widget.player2 is ComputerPlayer) {}
      isGameOver = false;
      canTap = true;
      isPlayer2Playing = false;
      winningPositions.clear();
      hints = null;
      winner = null;

      gameRoom.set(
        {
          'gameBoard': flattenGameBoard(gameBoard),
          'winner': winner,
          'currentPlayerNumber': currentPlayer.number,
          'isGameOver': isGameOver,
        },
        SetOptions(merge: true),
      );
    });
    Future.delayed(300.milliseconds, () {
      setState(() {
        canTap = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    /*  boardStream = gameRoom.snapshots().map((snapshot) {
      return snapshot.data()!['gameBoard'];
    }); */

    firstPlayer = widget.player1;
    currentPlayer = firstPlayer;
    initializeServerParameters();
    widget.player1.clearScore();
    widget.player2.clearScore();
    reset();

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color getColor(int? time) {
    if (time == null) {
      return Colors.green[400]!;
    } else {
      if (time > 10) {
        return Colors.green[400]!;
      } else {
        if (time > 5) {
          return Colors.yellow[400]!;
        }
        return Colors.red[400]!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color? turnColor = currentPlayer.number == 1 ? Colors.red : Colors.yellow;
    List<Color> turnColors = currentPlayer.number == 1
        ? [Colors.red[400]!, Colors.red[700]!]
        : [Colors.yellow[400]!, Colors.yellow[700]!];

    return OnBackPressed(
      perform: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: backgroundColor,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Are you sure you want to quit?',
                        style: TextStyle(
                          color: const Color.fromRGBO(255, 235, 59, 1),
                          fontSize: 16.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              gameRoom.delete();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'No',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            const Spacer(flex: 2),
            StreamBuilder(
                stream: gameRoom.snapshots().map((snapshot) {
                  return snapshot.data()!['players'];
                }),
                builder: (context, players) {
                  if (players.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(flex: 2),
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              if (!isPlayer2Playing)
                                NeonCircularTimer(
                                  width: 50.w,
                                  duration: 10,
                                  strokeWidth: 3.sp,
                                  controller: countDownController,
                                  isTimerTextShown: false,
                                  neumorphicEffect: true,
                                  isReverse: false,
                                  isReverseAnimation: true,
                                  backgroudColor: Colors.transparent,
                                  outerStrokeColor: Colors.transparent,
                                  onStart: () {},
                                  onComplete: () {
                                    setState(() {
                                      if (countDownController
                                              .getTimeInSeconds() >=
                                          9) {
                                        isGameOver = true;
                                        gameRoom.update({
                                          'isGameOver': isGameOver,
                                        });
                                        canTap = false;
                                        widget.player2.score++;
                                        gameRoom.snapshots().map((snapshot) {
                                          snapshot
                                              .data()!['players'][1]
                                              .update({
                                            'score': widget.player2.score,
                                          });
                                        });
                                        restartGame();
                                      }
                                    });
                                  },
                                  innerFillGradient: LinearGradient(colors: [
                                    Colors.yellow.shade400,
                                    Colors.yellow.shade200,
                                  ]),
                                ),
                              Image.asset(
                                'assets/images/avatars/avatar_${players.data![0]['avatar']}.png',
                                height: 40.h,
                                width: 40.w,
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            widget.player1.name!,
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
                          '${players.data![0]['score']} - ${players.data![1]['score']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              if (isPlayer2Playing)
                                NeonCircularTimer(
                                  width: 50.w,
                                  duration: 10,
                                  strokeWidth: 3.sp,
                                  controller: countDownController,
                                  isTimerTextShown: false,
                                  neumorphicEffect: false,
                                  isReverse: false,
                                  isReverseAnimation: true,
                                  backgroudColor: Colors.transparent,
                                  outerStrokeColor: Colors.transparent,
                                  onStart: () {},
                                  onComplete: () {
                                    setState(() {
                                      if (countDownController
                                              .getTimeInSeconds() >=
                                          9) {
                                        isGameOver = true;
                                        gameRoom.update({
                                          'isGameOver': isGameOver,
                                        });
                                        widget.player1.score++;
                                        gameRoom.snapshots().map((snapshot) {
                                          snapshot
                                              .data()!['players'][0]
                                              .update({
                                            'score': widget.player1.score,
                                          });
                                        });
                                        restartGame();
                                      }
                                    });
                                  },
                                  innerFillGradient: LinearGradient(colors: [
                                    Colors.yellow.shade400,
                                    Colors.yellow.shade200,
                                  ]),
                                ),
                              Image.asset(
                                'assets/images/avatars/avatar_${players.data![1]['avatar']}.png',
                                height: 40.h,
                                width: 40.w,
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            widget.player2.name!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(flex: 2),
                    ],
                  );
                }),
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
                        '${currentPlayer.id == playerID.toString() ? 'Your' : '${currentPlayer.name}\'s'} Turn',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      )
                    : Text(
                        switch (winner) {
                          0 => 'It\'s a tie!',
                          1 => 'You won!',
                          2 => '${widget.player2.name} won!',
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
              child: StreamBuilder(
                  stream: gameRoom.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      var data = snapshot.data!.data() as Map<String, dynamic>;
                      if (data['gameBoard'] != null) {
                        List<int> flattenedBoard =
                            List<int>.from(data['gameBoard']);
                        gameBoard = unflattenGameBoard(
                            flattenedBoard); // Assuming 7x7 board
                      }
                    }
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        buildBoard(),
                        buildDiscs(),
                        buildTapHighlight(),
                      ],
                    );
                  }),
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
                          List<int>? options = await widget.player1.getHints();
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

                      makeMove(
                          freeColumns[Random().nextInt(freeColumns.length)]);

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
                    hints = await widget.player1.getHints();
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
                List<Color> colors = [Colors.transparent, Colors.transparent];
                if (gameBoard[rowIndex][columnIndex] != 0) {
                  if (gameBoard[rowIndex][columnIndex] == 1) {
                    colors = [Colors.red[400]!, Colors.red[700]!];
                  } else if (gameBoard[rowIndex][columnIndex] == 2) {
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
                  !isPlayer2Playing &&
                  canDropInColumn()) {
                setState(() {
                  canTap = false;
                });
                makeMove(columnIndex);

                Future.delayed(300.milliseconds, () {
                  setState(() {
                    canTap = true;
                  });
                });
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
                borderRadius: BorderRadius.circular(10.sp),
              ),
            ),
          );
        },
      ),
    );
  }

  void highlightWinningPositions(PositionsList positions) {
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
      winner = '0';
      restartGame();
    }
  }

  Future<void> checkWin(int rowIndex) async {
    final List players = await gameRoom.get().then((snapshot) {
      return snapshot.data()!['players'];
    });
    if (checkHorizontal().isNotEmpty) {
      debugPrint('Player ${checkHorizontal()['winner']} wins!');
      Future.delayed((rowIndex * 100 + 200).milliseconds, () {
        highlightWinningPositions(
          checkHorizontal()['positions'],
        );
        setState(() {
          winner = checkHorizontal()['winner'];
        });
      });

      isGameOver = true;
      canTap = false;
      restartGame();
    } else if (checkVertical().isNotEmpty) {
      debugPrint('Player ${checkVertical()['winner']} wins!');
      Future.delayed((rowIndex * 100 + 200).milliseconds, () {
        highlightWinningPositions(
          checkVertical()['positions'],
        );

        setState(() {
          winner = checkVertical()['winner'];
        });
      });

      isGameOver = true;
      canTap = false;
      restartGame();
    } else if (checkDiagonal().isNotEmpty) {
      debugPrint('Player ${checkDiagonal()['winner']} wins!');
      Future.delayed((rowIndex * 100 + 200).milliseconds, () {
        highlightWinningPositions(
          checkDiagonal()['positions'],
        );

        setState(() {
          winner = checkDiagonal()['winner'];
        });
      });

      isGameOver = true;
      canTap = false;
      restartGame();
    }
    players.singleWhere((player) => player['id'] == winner)['score']++;
    gameRoom.update({
      'players': players,
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
              'winner': ,
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
        firstPlayer = firstPlayer.number == widget.player1.number
            ? widget.player2
            : widget.player1;
        reset();
      });
    });
  }
}
