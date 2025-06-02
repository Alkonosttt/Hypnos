import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class GNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;
  const GNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: GNav(
        selectedIndex: selectedIndex,
        onTabChange: onTabChange,
        tabBackgroundColor: Color(0xFF942F67),
        textStyle: GoogleFonts.comfortaa(),
        gap: 10,
        padding: EdgeInsets.all(8),
        tabs: [
          GButton(icon: Icons.music_note, text: 'library'),
          GButton(icon: Icons.favorite, text: 'favourites'),
          GButton(icon: Icons.timer, text: 'timer'),
          GButton(icon: Icons.settings, text: 'settings'),
        ],
      ),
    );
  }
}
