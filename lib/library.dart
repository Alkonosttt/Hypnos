import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
