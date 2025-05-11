import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(70, 100, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Positioned(
                        top: 10,
                        child: Container(
                          width: 37,
                          height: 37,
                          color: Color(0xFF942F67),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(
                          'HYPNOS',
                          style: GoogleFonts.instrumentSerif(fontSize: 60),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'an ambient sound library',
                    style: GoogleFonts.comfortaa(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset('assets/sleeping_Ariadna_dithered.png'),
          ),
        ],
      ),
    );
  }
}
