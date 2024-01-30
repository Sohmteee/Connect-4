import 'package:connect4/classes/position.dart';
import 'package:connect4/screens/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<List<int>> board = [
    [0, 0, 0, 1, 0],
    [0, 0, 1, 1, 0],
    [0, 1, 2, 1, 0],
    [1, 1, 1, 1, 1],
    [2, 2, 2, 1, 2],
  ];
  PositionsList highlightPositions = PositionsList([]);

  @override
  void initState() {
    Future.delayed(3.seconds, () {
      setState(() {
        highlightPositions = PositionsList(
          [
            Position(0, 3),
            Position(1, 2),
            Position(2, 1),
            Position(3, 0),
          ],
        );
      });
      Future.delayed(1.seconds, () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GameScreen(),
          ),
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            buildBoard(),
            buildDiscs(),
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
          5,
          (rowIndex) => Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              5,
              (columnIndex) {
                return Container(
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
          5,
          (rowIndex) => Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              5,
              (columnIndex) {
                Color? color;
                List<Color> colors = [];
                if (board[rowIndex][columnIndex] != 0) {
                  if (board[rowIndex][columnIndex] == 1) {
                    color = Colors.red;
                    colors = [Colors.red[400]!, Colors.red[700]!];
                  } else if (board[rowIndex][columnIndex] == 2) {
                    color = Colors.yellow;
                    colors = [Colors.yellow[400]!, Colors.yellow[700]!];
                  }
                }
                return board[rowIndex][columnIndex] == 0
                    ? Container(
                        width: 35.w,
                        height: 35.w,
                        margin: EdgeInsets.all(5.w),
                      ).animate().scaleXY(
                          end: .87,
                          duration: 300.milliseconds,
                          curve: Curves.bounceOut,
                        )
                    : ((columnIndex == 0 && rowIndex == 3) ||
                            (columnIndex == 1 && rowIndex == 2) ||
                            (columnIndex == 2 && rowIndex == 1) ||
                            (columnIndex == 3 && rowIndex == 0))
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
                            ),
                          )
                            .animate(onComplete: (controller) {})
                            .moveY(
                              begin: -((200 * (rowIndex + 2))).w,
                              end: 0,
                              duration: (rowIndex * 400 + 100).milliseconds,
                              delay: (columnIndex * 600 + 100).milliseconds,
                              curve: Curves.bounceOut,
                            )
                            .scaleXY(
                              end: .87,
                              duration: 300.milliseconds,
                              curve: Curves.bounceOut,
                            )
                            .then()
                            .scaleXY(
                              curve: Curves.easeOutSine,
                              delay: (rowIndex * 100 + 200).milliseconds,
                              duration: .2.seconds,
                              begin: 1,
                              end: .8,
                            )
                        : (highlightPositions
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
                            :  Container(
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
                          ).animate().scaleXY(
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
}
