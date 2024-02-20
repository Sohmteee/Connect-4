import 'package:connect4/dialogs/transparent_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

showNotYourTurnDialog(BuildContext context) {
  showTransparentDialog(
    context,
    duration: 2.seconds,
    child:  Center(
      child: Text(
        'It\'s Not Your Turn To Play Yet',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
