import 'package:connect4/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      body: Column(
        children: [
          const Spacer(flex: 2),
          Center(
            child: Text(
              'SETTINGS',
              style: TextStyle(
                fontSize: 50.sp,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
          ),
          const Spacer(flex: 4),
          const Spacer(flex: 4),
        ],
      ),
    );
  }
}
