import 'package:connect4/providers/settings.dart';
import 'package:connect4/screens/about.dart';
import 'package:connect4/screens/game.dart';
import 'package:connect4/screens/menu.dart';
import 'package:connect4/screens/settings.dart';
import 'package:connect4/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
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
            colorScheme:
                ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
            useMaterial3: true,
            fontFamily: 'Supercell',
          ),
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/menu': (context) => const MenuScreen(),
            '/game': (context) => const GameScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/about': (context) => const AboutScreen(),
          },
        );
      },
    );
  }
}
