import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// settings screens
import 'package:hypnos/loginandprofile.dart';
import 'package:hypnos/about.dart';
import 'package:hypnos/credits.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 8,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 70, 0, 50),
                child: Text(
                  'SETTINGS',
                  style: GoogleFonts.caesarDressing(fontSize: 45),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginProfileScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.login, size: 30),
                label: Text(
                  'log in',
                  style: GoogleFonts.comfortaa(fontSize: 30),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.info, size: 30),
                label: Text(
                  'about',
                  style: GoogleFonts.comfortaa(fontSize: 30),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreditsScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.approval_rounded, size: 30),
                label: Text(
                  'credits',
                  style: GoogleFonts.comfortaa(fontSize: 30),
                ),
              ),
            ],
          ),
        ),
        Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }
}
