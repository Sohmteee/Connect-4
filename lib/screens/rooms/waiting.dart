import 'dart:async';

import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen({super.key});

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  int dots = 0;
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(1.seconds, (t) {
      dots = (dots + 1) % 4;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(flex: 5),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
              Spacer(flex: 3),
              GameButton(text: 'CANCEL', onPressed: () {
                
              })
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
