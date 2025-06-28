import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 70, 0, 50),
            child: Text(
              'Favourites',
              style: GoogleFonts.caesarDressing(fontSize: 45),
            ),
          ),
          Expanded(child: Placeholder()),
        ],
      ),
    );
  }
}
