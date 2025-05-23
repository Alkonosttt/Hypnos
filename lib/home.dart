import 'package:flutter/material.dart';
// app screens
import 'package:hypnos/library.dart';
import 'package:hypnos/favourites.dart';
import 'package:hypnos/settings.dart';
import 'package:hypnos/timerpicker.dart';
// Google Nav Bar implementation
import 'package:hypnos/gnavbar.dart';

void main() {
  runApp(const HomeScreen());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // for navigation >>
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    LibraryPage(),
    FavouritesPage(),
    TimerPickerPage(),
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
        body: _screens[_selectedIndex],
        bottomNavigationBar: GNavBar(
          selectedIndex: _selectedIndex,
          onTabChange: _handleTabChange,
        ),
      ),
    );
  }
}
