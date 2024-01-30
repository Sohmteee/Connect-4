import 'package:connect4/dialogs/transparent_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

showNotYourTurnDialog(BuildContext context) {
  showTransparentDialog(
    context,
    duration: 2.seconds,
    child: const Center(
      child: Text(
        'It\'s Not Your Turn To Play Yet',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
