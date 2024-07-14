import 'package:audioplayers/audioplayers.dart';
import 'package:connect4/data/box.dart';
import 'package:connect4/data/controllers.dart';
import 'package:connect4/providers/audio.dart';
import 'package:connect4/screens/game.dart';
import 'package:connect4/screens/match_player.dart';
import 'package:connect4/screens/menu.dart';
import 'package:connect4/screens/rooms/create.dart';
import 'package:connect4/screens/rooms/join.dart';
import 'package:connect4/screens/settings.dart';
import 'package:connect4/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/rooms/room.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  final dir = await getApplicationDocumentsDirectory();
  Hive.openBox("myBox", path: dir.path);
  box = await Hive.openBox("myBox");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Connect 4',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurpleAccent,
            ),
            useMaterial3: true,
            fontFamily: 'Supercell',
          ),
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/menu': (context) => const MenuScreen(),
            '/game': (context) => const GameScreen(
                secondPlayer: {'name': 'Player 2', 'avatar': 13}),
            '/settings': (context) => const SettingsScreen(),
            '/room': (context) => const RoomScreen(),
            '/create-room': (context) => const CreateRoomScreen(),
            '/join-room': (context) => const JoinRoomScreen(),
            '/match': (context) => const MatchPlayerScreen(),
          },
        );
      },
    );
  }
}

Future<void> playTap(context) async {
  final audioProvider = Provider.of<AudioProvider>(context, listen: false);

  if (audioProvider.soundEffects) {
    await tapPlayer.stop();
    await tapPlayer.play(AssetSource("audio/tap.mp3"));

    debugPrint("Play Tap");
  }
}

Future<void> playCorrect(context) async {
  final audioProvider = Provider.of<AudioProvider>(context, listen: false);

  if (audioProvider.soundEffects) {
    await correctPlayer.stop();
    await correctPlayer.play(AssetSource("audio/correct.mp3"));

    debugPrint("Play Correct");
  }
}

Future<void> playWrong(context) async {
  final audioProvider = Provider.of<AudioProvider>(context, listen: false);

  if (audioProvider.soundEffects) {
    await wrongPlayer.stop();
    await wrongPlayer.play(AssetSource("audio/wrong.mp3"));

    debugPrint("Play Wrong");
  }
}

Future<void> playUnavailable(context) async {
  final audioProvider = Provider.of<AudioProvider>(context, listen: false);

  if (audioProvider.soundEffects) {
    await unavailablePlayer.stop();
    await unavailablePlayer
        .play(AssetSource("audio/unavailable-selection.mp3"));

    debugPrint("Play Unavailable");
  }
}

Future<void> playVictory(context) async {
  final audioProvider = Provider.of<AudioProvider>(context, listen: false);

  if (audioProvider.soundEffects) {
    await victoryPlayer.setSource(AssetSource("audio/victory.mp3"));
    await victoryPlayer.resume();
  }
}

Future<void> playLevel(context) async {
  final audioProvider = Provider.of<AudioProvider>(context, listen: false);

  if (audioProvider.soundEffects) {
    await levelPlayer.setSource(AssetSource("audio/stage.mp3"));
    await levelPlayer.resume();
  }
}

Future<void> playRedeem(context) async {
  final audioProvider = Provider.of<AudioProvider>(context, listen: false);

  if (audioProvider.soundEffects) {
    await redeemPlayer.setSource(AssetSource("audio/redeem.mp3"));
    await redeemPlayer.resume();
  }
}

Future<void> playCoinUp(context) async {
  final audioProvider = Provider.of<AudioProvider>(context, listen: false);

  if (audioProvider.soundEffects) {
    await coinUpPlayer.setSource(AssetSource("audio/coin-up.mp3"));
    await coinUpPlayer.resume();
  }
}

Future<void> playCoinDown(context) async {
  final audioProvider = Provider.of<AudioProvider>(context, listen: false);

  if (audioProvider.soundEffects) {
    await coinDownPlayer.setSource(AssetSource("audio/coin-down.mp3"));
    await coinDownPlayer.resume();
  }
}
