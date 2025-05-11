import 'package:flutter/material.dart';
// app screens
import 'package:hypnos/library.dart';
import 'package:hypnos/favourites.dart';
import 'package:hypnos/settings.dart';
// Google Nav Bar implementation
import 'package:hypnos/gnavbar.dart';
// splash screen
import 'package:hypnos/splash.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // for navigation >>
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    LibraryPage(),
    FavouritesPage(),
    SettingsPage(),
  ];

  void _handleTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  // for navigation <<

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hypnos',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: Scaffold(
        //body: _screens[_selectedIndex],
        body: SplashScreen(),
        /*bottomNavigationBar: GNavBar(
          selectedIndex: _selectedIndex,
          onTabChange: _handleTabChange,
        ),*/
      ),
    );
  }
}
