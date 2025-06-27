import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// individual settings screens
import 'package:hypnos/loginandprofile.dart';
import 'package:hypnos/about.dart';
import 'package:hypnos/credits.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Widget _buildSettingsButton({
    required IconData icon,
    required String label,
    required Widget targetScreen,
  }) {
    return TextButton.icon(
      style: TextButton.styleFrom(foregroundColor: Colors.white),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetScreen),
        );
      },
      icon: Icon(icon, size: 30, color: Color(0xFF942F67)),
      label: Text(label, style: GoogleFonts.comfortaa(fontSize: 30)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 8,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 70, 0, 50),
                child: Text(
                  'Settings',
                  style: GoogleFonts.caesarDressing(fontSize: 45),
                ),
              ),
              _buildSettingsButton(
                icon: Icons.login,
                label: 'log in',
                targetScreen: const LoginProfileScreen(),
              ),
              _buildSettingsButton(
                icon: Icons.info,
                label: 'about',
                targetScreen: const AboutScreen(),
              ),
              _buildSettingsButton(
                icon: Icons.approval_rounded,
                label: 'credits',
                targetScreen: const CreditsScreen(),
              ),
            ],
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }
}
