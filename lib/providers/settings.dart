import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool music = false;
  bool sound = false;
  double volume = 0.5;

  void toggleMusic(bool value) {
    music = value;
    notifyListeners();
  }

  void toggleSound(bool value) {
    sound = value;
    notifyListeners();
  }

  void setVolumne(bool value) {
    sound = value;
    notifyListeners();
  }
}
