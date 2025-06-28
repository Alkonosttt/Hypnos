import 'package:flutter/material.dart';
// for ChangeNotifier
import 'package:provider/provider.dart';
// home screen
import 'package:hypnos/screens/home.dart';
// splash screen
import 'package:hypnos/screens/splash.dart';
// global audio service
import 'package:hypnos/services/globalaudioplayerservice.dart';
// favourite service
import 'package:hypnos/services/favouritesservice.dart';

// TODO: open in Xcode and edit ios/Runner/LaunchScreen.storyboard
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalAudioService()),
        ChangeNotifierProvider(create: (_) => FavouritesService()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // handling the display of the splash screen >>
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _showSplash = false;
      });
    });
  }
  // handling the display of the splash screen <<

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      title: 'Hypnos',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: _showSplash ? SplashScreen() : HomeScreen(),
    );
  }
}
