import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'globalaudioplayerservice.dart';

class SoundItem {
  // image names match the corresponding audio names
  final String imagePath;
  final String audioPath;
  final String displayName;

  SoundItem({
    required this.imagePath,
    required this.audioPath,
    required this.displayName,
  });
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
            // audio names match the image names, replacing the format
            imagePath:
                'assets/images/photos/${entry.key.replaceAll('.mp3', '.jpg')}',
            displayName: entry.value,
          );
        }).toList();
  }

  void togglePlay(SoundItem item) async {
    final audioPath = item.audioPath;
    final service = GlobalAudioService();
    if (service.isPlaying(audioPath)) {
      await service.pause(audioPath);
    } else {
      await service.play(audioPath);
    }
    // forcing UI to update
    setState(() {});
  }

  void changeVolume(SoundItem item, double volume) async {
    await GlobalAudioService().setVolume(item.audioPath, volume);
    // forcing UI to update
    setState(() {});
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
        final isPlaying = GlobalAudioService().isPlaying(item.audioPath);
        final volume = GlobalAudioService().volume(item.audioPath);
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
                    if (!isPlaying)
                      Icon(
                        Icons.play_circle_fill,
                        size: 48,
                        color: Colors.white,
                      ),
                    if (isPlaying)
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
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        item.displayName,
                        style: GoogleFonts.comfortaa(fontSize: 20),
                      ),
                    ),
                    // volume slider
                    Slider(
                      value: volume,
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
