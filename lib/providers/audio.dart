import 'package:audioplayers/audioplayers.dart';
import 'package:connect4/data/box.dart';
import 'package:connect4/data/controllers.dart';
import 'package:flutter/material.dart';

class AudioProvider extends ChangeNotifier {
  double volume = box.get("volume", defaultValue: .7);
  bool music = box.get("music", defaultValue: true);
  bool soundEffects = box.get("soundEffects", defaultValue: true);

  toggleMusic(bool value) async {
    music = value;
    box.put("music", value);

    if (value) {
      String bgAudio = "audio/bg-music.mp3";
      await bgPlayer.setSource(AssetSource(bgAudio));
      await bgPlayer.resume();
    } else {
      bgPlayer.stop();
    }
    notifyListeners();
  }

  toggleSoundEffects(bool value) {
    soundEffects = value;
    box.put("soundEffects", value);
    notifyListeners();
  }

  setVolume(double newVolume) {
    volume = newVolume;
    box.put("volume", newVolume);

    bgPlayer.setVolume(newVolume);
    tapPlayer.setVolume(newVolume / 2);
    correctPlayer.setVolume(newVolume);
    wrongPlayer.setVolume(newVolume / 2);
    unavailablePlayer.setVolume(newVolume / 2);
    victoryPlayer.setVolume(newVolume);
    levelPlayer.setVolume(newVolume / 2);
    coinUpPlayer.setVolume(newVolume);
    coinDownPlayer.setVolume(newVolume);
    redeemPlayer.setVolume(newVolume);

    if (newVolume == 0) {
      music = false;
      box.put("music", false);
      soundEffects = false;
      box.put("soundEffects", false);
    }
    notifyListeners();
  }

 
}
