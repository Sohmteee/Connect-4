import 'package:connect4/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

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
          const SizedBox(height: 100),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/game');
            },
            child: const Text('Play'),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            decoration: BoxDecoration(
              color: Colors.deepPurple[800],
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Text(
              'Play ',
              style: TextStyle(
                color: Colors.deepPurple[100],
                fontSize: 18.sp,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ZoomTapAnimation(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/game button.png'),
                ),
              ),
              child: Center(
                child: Text(
                  'Play ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            child: const Text('Settings'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
            child: const Text('About'),
          ),
        ],
      ),
    );
  }
}
