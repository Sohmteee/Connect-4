import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/widgets/button.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const SizedBox(height: 100),
          Center(
            child: Text(
              'CONNECT 4',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[100],
              ),
            ),
          ),
          const Spacer(),
          GameButton(
            text: 'Play',
            onPressed: () {},
          ),
          const SizedBox(height: 30),
          GameButton(
            text: 'Settings',
            onPressed: () {},
          ),
          const SizedBox(height: 30),
          GameButton(
            text: 'About',
            onPressed: () {},
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
