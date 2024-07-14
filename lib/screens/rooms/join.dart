import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/main.dart';
import 'package:connect4/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        leading: const BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          children: [
            Text(
              'Join Room',
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 3),
            TextField(
              style: TextStyle(
                color: Colors.grey[100],
              ),
              decoration: const InputDecoration(
                labelText: 'Room Name',
                border: OutlineInputBorder(),
              ),
              onTapOutside: (e) {
                FocusScope.of(context).unfocus();
              },
            ),
            const Spacer(),
            TextField(
              style: TextStyle(
                color: Colors.grey[100],
              ),
              decoration: const InputDecoration(
                labelText: 'Room Key',
                border: OutlineInputBorder(),
              ),
              onTapOutside: (e) {
                FocusScope.of(context).unfocus();
              },
            ),
            const Spacer(flex: 4),
            GameButton(
              text: 'JOIN',
              onPressed: () {
                playTap(context);
              },
            ),
            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
