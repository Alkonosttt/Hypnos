import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hypnos/librarygrid.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 70, 0, 50),
            child: Text(
              'Ambient library',
              style: GoogleFonts.caesarDressing(fontSize: 45),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                TextButton(
                  onPressed:
                      () =>
                          throw UnimplementedError(
                            'Button press not yet implemented',
                          ),
                  child: Text('set a timer'),
                ),
              ],
            ),
          ),
          Expanded(child: LibraryGrid()),
        ],
      ),
    );
  }
}
