import 'package:flutter/material.dart';

showTransparentDialog(
  BuildContext context, {
  required Widget child,
  Duration duration = const Duration(milliseconds: 1500),
}) {
  showDialog(
    context: context,
    builder: (context) {
      Future.delayed(duration, () {
        Navigator.of(context).pop();
      });
      return Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: Colors.transparent,
        ),
        child: PopScope(
          canPop: false,
          child: Dialog(
            elevation: 0,
            child: Container(
              color: Colors.transparent,
              child: child,
            ),
          ),
        ),
      );
    },
  );
}
