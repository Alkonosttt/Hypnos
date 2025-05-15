import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundItem {
  final String name;
  final String imagePath;
  final String audioPath;

  bool isPlaying;
  double volume;
  AudioPlayer player;

  SoundItem({
    required this.name,
    required this.imagePath,
    required this.audioPath,
    this.isPlaying = false,
    this.volume = 1.0,
  }) : player = AudioPlayer();
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final List<String> soundNames = [
    '40_hz_binaural',
    'airplane_ambience',
    'calming_rain',
    'ceiling_fan_closeup_hum',
    'cicada_buzzing',
    'creek',
    'cricket',
    'fire_sound',
    'forest_bird_harmonies',
    'frogs_croaking',
    'inside_old_train',
    'light_rain',
    'ocean_waves',
    'pendulum_clock_tic_tac',
    'soft_wind',
    'swamp_woods',
    'thunderstorm',
    'ticking_clock',
    'typing_on_laptop_keyboard',
    'wind_blowing',
  ];
  late List<SoundItem> items;

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
                // placeholder for library items
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
