import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/screens/game.dart';
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
                fontSize: 40.sp,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
          ),
          const Spacer(flex: 4),
          GameButton(
            text: 'PLAY WITH\nCOMPUTER',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GameScreen(
                    gameMode: GameMode.singlePlayer,
                  ),
                ),
              );
            },
          ),
          const Spacer(),
          GameButton(
            text: 'PLAY WITH\nFRIEND',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GameScreen(
                    gameMode: GameMode.twoPlayersOffline,
                  ),
                ),
              );
            },
          ),
          const Spacer(flex: 4),
        ],
      ),
    );
  }
}
