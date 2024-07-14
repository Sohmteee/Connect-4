import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/main.dart';
import 'package:connect4/widgets/button.dart';
import 'package:flutter/material.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

final roomName = TextEditingController();
final roomKey = TextEditingController();

class _RoomScreenState extends State<RoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 5),
            /* Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Create or  join a room to play',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(flex: 3), */
            GameButton(
              text: 'CREATE ROOM',
              onPressed: () {
                playTap(context);
                Navigator.pushNamed(context, '/create-room');
              },
            ),
            const Spacer(flex: 1),
            GameButton(
              text: 'JOIN ROOM',
              onPressed: () {
                playTap(context);
                Navigator.pushNamed(context, '/join-room');
              },
            ),
            const Spacer(flex: 5),
          ],
        ),
      ),
    );
  }
}
