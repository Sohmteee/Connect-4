import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool music = false;
  bool sound = false;

  void toggleMusic() {
    music = !music;
    notifyListeners();
  }

  void toggleSound() {
    sound = !sound;
    notifyListeners();
  }
}
