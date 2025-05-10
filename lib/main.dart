import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        //fontFamily: 'YourFontName',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: Scaffold(
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
