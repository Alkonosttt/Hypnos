import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            tabBackgroundColor: Color(0xFF942F67),
            gap: 10,
            // TODO: add tab functionality
            onTabChange: (index) {},
            padding: EdgeInsets.all(8),
            tabs: [
              GButton(icon: Icons.music_note, text: 'library'),
              GButton(icon: Icons.favorite, text: 'favourites'),
              GButton(icon: Icons.settings, text: 'settings'),
            ],
          ),
        ),
        body: Row(
          children: <Widget>[
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 8,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 70, 0, 50),
                    child: Text(
                      'AMBIENT LIBRARY',
                      style: GoogleFonts.instrumentSerif(fontSize: 45),
                    ),
                  ),
                  Text('plaques', style: GoogleFonts.comfortaa(fontSize: 20)),
                ],
              ),
            ),
            Expanded(flex: 1, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
