import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class GameButton extends StatelessWidget {
  const GameButton({super.key, this.text, this.onPressed});

  

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
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
    );
  }
}
