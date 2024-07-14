import 'package:audioplayers/audioplayers.dart';
import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/data/controllers.dart';
import 'package:connect4/main.dart';
import 'package:connect4/providers/audio.dart';
import 'package:connect4/widgets/button.dart';
import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    playBGAudio(context);
    // Future.microtask(() => initializeEffectsVolume());
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        playBGAudio(context);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        pauseBGAudio();
        break;
      case AppLifecycleState.detached:
        stopBGAudio();
        break;
    }
  }

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
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
            ),
            const Spacer(flex: 4),
            GameButton(
              text: 'PLAY',
              onPressed: () {
                playTap(context);
                Navigator.pushNamed(context, '/room');
              },
            ),
            const Spacer(),
            GameButton(
              text: 'LEADERBOARD',
              onPressed: () {
                playTap(context);
                // Navigator.pushNamed(context, '/match');
              },
            ),
            const Spacer(),
            GameButton(
              text: 'SETTINGS',
              onPressed: () {
                playTap(context);
                showDialog(
                    context: context,
                    builder: (context) {
                      return buildSettings();
                    });
              },
            ),
            const Spacer(),
            GameButton(
              text: 'ABOUT',
              onPressed: () {
                playTap(context);
                // Navigator.pushNamed(context, '/about');
              },
            ),
            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }

  Dialog buildSettings() {
    final provider = Provider.of<AudioProvider>(context);

    return Dialog(
      child: Container(
        padding: EdgeInsets.fromLTRB(10.w, 20.h, 0.w, 20.h),
        decoration: const BoxDecoration(),
        child: StatefulBuilder(builder: (context, updateState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                value: provider.music,
                onChanged: (value) {
                  playTap(context);
                  updateState(() {
                    provider.toggleMusic(value);
                  });
                },
                title: Text(
                  'Music',
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                inactiveThumbColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
                trackOutlineColor: MaterialStateColor.resolveWith(
                  (states) => backgroundColor!,
                ),
                activeColor: backgroundColor,
              ),
              SwitchListTile(
                value: provider.soundEffects,
                onChanged: (value) {
                  playTap(context);
                  updateState(() {
                    provider.toggleSoundEffects(value);
                  });
                },
                title: Text(
                  'Sound',
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                inactiveThumbColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
                trackOutlineColor: MaterialStateColor.resolveWith(
                  (states) => backgroundColor!,
                ),
                activeColor: backgroundColor,
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  const SizedBox(width: 15),
                  Text(
                    'Volume',
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              Slider.adaptive(
                value: provider.volume,
                onChanged: (value) {
                  playTap(context);
                  updateState(() {
                    provider.setVolume(value);
                  });
                },
                activeColor: backgroundColor,
                divisions: 10,
                label: '${(provider.volume * 100).toInt()}%',
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> playBGAudio(context) async {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    if (audioProvider.music) {
      await bgPlayer.setSource(AssetSource("audio/bg-music.mp3"));
      await bgPlayer.resume();
      debugPrint("music playing");
    }

    bgPlayer.onPlayerComplete.listen((_) async {
      await bgPlayer.setSource(AssetSource("audio/bg-music.mp3"));
      Future.delayed(const Duration(seconds: 5), () async {
        await bgPlayer.resume();
      });
    });
  }

  Future<void> pauseBGAudio() async {
    await bgPlayer.pause();
    debugPrint("music paused");
  }

  Future<void> stopBGAudio() async {
    await bgPlayer.stop();
    debugPrint("music stopped");
  }
}
