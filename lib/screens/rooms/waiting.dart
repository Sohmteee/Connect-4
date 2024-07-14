import 'dart:async';

import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/screens/rooms/room.dart';
import 'package:connect4/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen({super.key});

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  ValueNotifier<int> dots = ValueNotifier<int>(0);
  ValueNotifier<int> countdown = ValueNotifier<int>(300);
  late Timer timer;
  Timer? startTimer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (t.tick == 300) {
        room.doc(roomName.text).delete();
        Navigator.pop(context);
      }

      dots.value = (dots.value + 1) % 4;
      countdown.value = 300 - t.tick;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    startTimer?.cancel();
    dots.dispose();
    countdown.dispose();
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
          child: StreamBuilder<int>(
            stream: getNumberOfPlayersStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingAnimationWidget.inkDrop(
                  color: backgroundColor!,
                  size: 50.sp,
                );
              } else if (snapshot.hasData && snapshot.data == 1) {
                return _waitingForPlayerWidget();
              } else if (snapshot.hasData && snapshot.data! > 1) {
                startTimer ??= Timer.periodic(const Duration(seconds: 1), (t) {
                  if (t.tick == 10) {
                    startTimer?.cancel();
                  }
                  setState(() {});
                });
                return _foundPlayerWidget();
              } else {
                return const Text('The room does not exist');
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _waitingForPlayerWidget() {
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
            ValueListenableBuilder<int>(
              valueListenable: dots,
              builder: (context, value, child) {
                return Text(
                  '.' * value,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ],
        ),
        const Spacer(flex: 2),
        ValueListenableBuilder<int>(
          valueListenable: countdown,
          builder: (context, value, child) {
            return Text(
              '${value}s',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            );
          },
        ),
        const Spacer(flex: 2),
        GameButton(
          text: 'CANCEL',
          onPressed: () {
            room.doc(roomName.text).delete();
            Navigator.pop(context);
          },
        ),
        const Spacer(flex: 2),
      ],
    );
  }

  Widget _foundPlayerWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(flex: 5),
        Text(
          'Found a player!',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 2),
        Text(
          'Match starts in ${10 - (startTimer?.tick ?? 0)}s',
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
          },
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
