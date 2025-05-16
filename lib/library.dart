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
    return Scaffold(body: LibraryGrid());
  }
}
