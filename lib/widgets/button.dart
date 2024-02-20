import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class GameButton extends StatelessWidget {
  const GameButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.white,
    this.padding,
    this.width,
  });

  final String text;
  final VoidCallback onPressed;
  final Color color;
  final EdgeInsets? padding;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: onPressed,
      child: Container(
        width: width ?? 200.w,
        padding: padding ??
            EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 25.w,
            ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.asset('assets/images/game button.png', fit: ,).image,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}
