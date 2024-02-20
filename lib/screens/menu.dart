import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/providers/settings.dart';
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
                Navigator.pushNamed(context, '/play-options');
              },
            ),
            const Spacer(),
            GameButton(
              text: 'SETTINGS',
              onPressed: () {
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
    final provider = Provider.of<SettingsProvider>(context);

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
                value: provider.sound,
                onChanged: (value) {
                  updateState(() {
                    provider.toggleSound(value);
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
              Slider.adaptive(
                value: provider.volume,
                onChanged: (value) {
                  updateState(() {
                    provider.setVolumne(value);
                  });
                },
                activeColor: backgroundColor,
                divisions: 10,
                label: '(provider.volume * 100)'',
              ),
            ],
          );
        }),
      ),
    );
  }
}
