import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayOptionsScreen extends StatefulWidget {
  const PlayOptionsScreen({super.key});

  @override
  State<PlayOptionsScreen> createState() => _PlayOptionsScreenState();
}

class _PlayOptionsScreenState extends State<PlayOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const Spacer(flex: 2),
          Center(
            child: Text(
              'CONNECT 4',
              style: TextStyle(
                fontSize: 50.sp,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
          ),
          const Spacer(flex: 4),
          GameButton(
            text: 'PLAY WITH COMPUTER',
            onPressed: () {
              Navigator.pushNamed(context, '/game');
            },
            padding: EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 105.w,
            ),
          ),
          const Spacer(),
          GameButton(
            text: 'PLAY WITH FRIEND',
            onPressed: () {},
          ),
          const Spacer(flex: 4),
        ],
      ),
    );
  }
}
