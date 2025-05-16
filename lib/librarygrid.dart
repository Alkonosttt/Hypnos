import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundItem {
  final String imagePath;
  final String audioPath;
  final String displayName;

  bool isPlaying;
  double volume;
  AudioPlayer player;

  SoundItem({
    required this.imagePath,
    required this.audioPath,
    required this.displayName,
    this.isPlaying = false,
    this.volume = 1.0,
  }) : player = AudioPlayer();
}

class LibraryGrid extends StatefulWidget {
  const LibraryGrid({super.key});

  @override
  State<LibraryGrid> createState() => _LibraryGridState();
}

class _LibraryGridState extends State<LibraryGrid> {
  // mapping between the audio asset name and the corresponding display name
  final Map<String, String> displayNames = {
    '40_hz_binaural.mp3': '40 HZ',
    'airplane_ambience.mp3': 'airplane',
    'calming_rain.mp3': 'downpour',
    'ceiling_fan_closeup_hum.mp3': 'ceiling fan',
    'cicada_buzzing.mp3': 'cicada',
    'creek.mp3': 'creek',
    'cricket.mp3': 'cricket',
    'fire_sound.mp3': 'fire',
    'forest_bird_harmonies.mp3': 'tropical birds',
    'frogs_croaking.mp3': 'frogs',
    'inside_old_train.mp3': 'old train',
    'light_rain.mp3': 'light rain',
    'ocean_waves.mp3': 'ocean waves',
    'pendulum_clock_tic_tac.mp3': 'pendulum clock',
    'soft_wind.mp3': 'soft wind',
    'swamp_woods.mp3': 'swamp woods',
    'thunderstorm.mp3': 'thunderstorm',
    'ticking_clock.mp3': 'clock',
    'typing_on_laptop_keyboard.mp3': 'laptop keyboard',
    'wind_blowing.mp3': 'wind',
  };
  late List<SoundItem> audioItems;
  @override
  void initState() {
    super.initState();
    audioItems =
        displayNames.entries.map((entry) {
          return SoundItem(
            audioPath: 'assets/audio/${entry.key}',
            imagePath:
                'assets/images/photos/${entry.key.replaceAll('.mp3', '.jpg')}',
            displayName: entry.value,
          );
        }).toList();
  }

  void togglePlay(SoundItem item) async {
    if (item.isPlaying) {
      await item.player.pause();
    } else {
      await item.player.setSource(
        AssetSource(item.audioPath.replaceFirst('assets/', '')),
      );
      await item.player.setVolume(item.volume);
      // loops the audio
      await item.player.setReleaseMode(ReleaseMode.loop);
      await item.player.resume();
    }

    setState(() {
      item.isPlaying = !item.isPlaying;
    });
  }

  void changeVolume(SoundItem item, double volume) async {
    await item.player.setVolume(volume);
    setState(() {
      item.volume = volume;
    });
  }

  @override
  void dispose() {
    for (var item in audioItems) {
      item.player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // two columns of library items
        crossAxisCount: 2,
        childAspectRatio: 0.75,
      ),
      itemCount: audioItems.length,
      itemBuilder: (context, index) {
        final item = audioItems[index];
        return Card(
          elevation: 4,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => togglePlay(item),
                // play icon overlayed on the photo
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(item.imagePath, height: 120, fit: BoxFit.cover),
                    if (!item.isPlaying)
                      Icon(
                        Icons.play_circle_fill,
                        size: 48,
                        color: Colors.white,
                      ),
                    if (item.isPlaying)
                      Icon(
                        Icons.pause_circle_filled,
                        size: 48,
                        color: Colors.white,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Column(
                  children: [
                    // display name
                    Text(
                      item.displayName,
                      style: GoogleFonts.instrumentSerif(fontSize: 25),
                    ),
                    // volume slider
                    Slider(
                      value: item.volume,
                      onChanged: (v) => changeVolume(item, v),
                      min: 0.0,
                      max: 1.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
