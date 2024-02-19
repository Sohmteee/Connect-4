import 'package:connect4/colors/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: const Column(
        children: [
          Spacer(flex: 2),
          Center(
            child: Text(
              'SETTINGS',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
          ),
          Spacer(flex: 4),
          
          Spacer(flex: 4),
        ],
      ),
    );
  }
}
