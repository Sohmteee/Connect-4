import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/widgets/button.dart';
import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return DoubleTapToExit(
      snackBar: SnackBar(
                content: Text('Tap again to exit!'),
                
              ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            const Spacer(flex: 2),
            const Center(
              child: Text(
                'CONNECT 4',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
            ),
            const Spacer(flex: 5),
            GameButton(
              text: 'Play',
              onPressed: () {
                Navigator.pushNamed(context, '/game');
              },
            ),
            const Spacer(),
            GameButton(
              text: 'Settings',
              onPressed: () {},
            ),
            const Spacer(),
            GameButton(
              text: 'About',
              onPressed: () {},
            ),
            const Spacer(flex: 5),
          ],
        ),
      ),
    );
  }
}
