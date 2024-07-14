import 'dart:async';

import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/screens/rooms/room.dart';
import 'package:connect4/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen({super.key, required this.hasOpponent});

  final bool hasOpponent;

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  int dots = 0;
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(1.seconds, (t) {
      if (timer.tick == 300) {
        room.doc(roomName.text).delete();
        Navigator.pop(context);
      }

      dots = (dots + 1) % 4;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Stream<int> getNumberOfPlayersStream() {
    return room.doc(roomName.text).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data()!['players'].length;
      } else {
        return 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: StreamBuilder(
            stream: getNumberOfPlayersStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return LoadingAnimationWidget.inkDrop(
                        color: backgroundColor!,
                        size: 50.sp,
                      );
                    });
              } else if (snapshot.data == 1) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 5),
                    Text(
                      'Waiting for player to',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width:
                                (MediaQuery.of(context).size.width / 2) - 40.w),
                        Text(
                          'join',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '.' * dots,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const Spacer(flex: 2),
                    Text(
                      '${300 - timer.tick}s',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                    ),
                    const Spacer(flex: 2),
                    GameButton(
                        text: 'CANCEL',
                        onPressed: () {
                          room.doc(roomName.text).delete();
                          Navigator.pop(context);
                        }),
                    const Spacer(flex: 2),
                  ],
                );
              } 
                return Container();
              
            },
          ),
        ),
      ),
    );
  }
}
