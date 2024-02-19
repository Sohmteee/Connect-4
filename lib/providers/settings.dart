import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool music = false;
  bool sound = false;

  void toggleMusic(bool value) {
    music = value;
    notifyListeners();
  }

  void toggleSound(bool value) {
    sound = value;
    notifyListeners();
  }
}
