import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// library entries
import 'package:hypnos/widgets/librarygrid.dart';
// timer button
import 'package:hypnos/widgets/globalfab.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SleepTimerFAB(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 70, 0, 50),
            child: Text(
              'Library',
              style: GoogleFonts.caesarDressing(fontSize: 45),
            ),
          ),
          Expanded(child: LibraryGrid()),
        ],
      ),
    );
  }
}
