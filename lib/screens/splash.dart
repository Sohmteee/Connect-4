import 'package:connect4/classes/position.dart';
import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showBoard = true;
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
    Future.delayed(2.8.seconds, () {
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
      Future.delayed(1.4.seconds, () {
        setState(() {
          showBoard = false;
        });
      });
      Future.delayed(5.seconds, () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MenuScreen(),
          ),
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SizedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (showBoard) buildBoard(),
              Stack(
                alignment: Alignment.centerLeft,
                clipBehavior: Clip.none,
                children: [
                  showBoard ? buildDiscs() : buildCompressedDiscs(),
                  if (!showBoard)
                    Positioned(
                      left: -50.w,
                      child: Column(
                        children: [
                          SizedBox(height: 40.h),
                          Text(
                            'CONNECT',
                            style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ).animate().moveX(
                          delay: .3.seconds,
                          begin: -250.w,
                          end: 0,
                          duration: .5.seconds,
                          curve: Curves.bounceOut,
                        ),
                ],
              ),
            ],
          ),
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
                List<Color> colors = [
                  Colors.transparent,
                  Colors.transparent,
                ];
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
                        color: Colors.transparent,
                      ).animate().scaleXY(
                          end: .87,
                          duration: 300.milliseconds,
                          curve: Curves.bounceOut,
                        )
                    : ((columnIndex == 0 && rowIndex == 3) ||
                            (columnIndex == 1 && rowIndex == 2) ||
                            (columnIndex == 2 && rowIndex == 1) ||
                            (columnIndex == 3 && rowIndex == 0))
                        ? (highlightPositions
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
                        : AnimatedContainer(
                            duration: .4.seconds,
                            width: 35.w,
                            height: 35.w,
                            margin: EdgeInsets.all(5.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: (!showBoard &&
                                      board[rowIndex][columnIndex] == 2)
                                  ? const LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                    )
                                  : LinearGradient(
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

  Widget buildCompressedDiscs() {
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
                List<Color> colors = [Colors.transparent, Colors.transparent];
                if (board[rowIndex][columnIndex] != 0) {
                  if (board[rowIndex][columnIndex] == 1) {
                    colors = [Colors.red[400]!, Colors.red[700]!];
                  } else if (board[rowIndex][columnIndex] == 2) {
                    colors = [Colors.yellow[400]!, Colors.yellow[700]!];
                  }
                }
                return Container(
                  width: 35.w,
                  height: 35.w,
                  margin: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: board[rowIndex][columnIndex] == 1
                          ? Colors.white
                          : Colors.transparent,
                      width: 3.sp,
                    ),
                    gradient: (board[rowIndex][columnIndex] == 1)
                        ? LinearGradient(
                            colors: colors,
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          )
                        : LinearGradient(
                            colors: [
                              colors[0].withOpacity(0),
                              colors[1].withOpacity(0),
                            ],
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
    )
        .animate()
        .scaleXY(
          end: .5,
          duration: 500.milliseconds,
          curve: Curves.easeOutSine,
        )
        .moveX(
          end: 110.w,
          duration: 500.milliseconds,
          curve: Curves.easeOutSine,
        );
  }
}
