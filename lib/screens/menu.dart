import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/widgets/button.dart';
import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return DoubleTapToExit(
      snackBar: const SnackBar(
        content: Text(
          'Tap again to exit!',
          textAlign: TextAlign.center,
        ),
      ),
      child: Scaffold(
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
              text: 'PLAY',
              onPressed: () {
                Navigator.pushNamed(context, '/game');
              },
            ),
            const Spacer(),
            GameButton(
              text: 'SETTINGS',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 50.h,
                            horizontal: 25.w,
                          ),
                          decoration: const BoxDecoration(),
                          child: Container(),
                        ),
                      );
                    });
              },
            ),
            const Spacer(),
            GameButton(
              text: 'ABOUT',
              onPressed: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
