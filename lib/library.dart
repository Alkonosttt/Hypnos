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
  void initState() {
    super.initState();
    items =
        soundNames.map((name) {
          return SoundItem(
            name: name,
            imagePath: 'assets/images/photos/$name.jpg',
            audioPath: 'assets/audio/$name.mp3',
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
    for (var item in items) {
      item.player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 8,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => togglePlay(item),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              item.imagePath,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
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
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
            ),
          ),
          Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}
