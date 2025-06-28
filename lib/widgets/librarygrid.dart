import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// for Consumer
import 'package:provider/provider.dart';
// global audio service
import '../services/globalaudioplayerservice.dart';
// to allow adding favourites
import '../models/favouritesmodels.dart';
import '../services/favouritesservice.dart';

class SoundItem {
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
    final service = context.read<GlobalAudioService>();
    final audioPath = item.audioPath;

    if (service.isPlaying(audioPath)) {
      await service.pause(audioPath);
    } else {
      await service.play(audioPath);
    }

    setState(() {});
  }

  void changeVolume(SoundItem item, double volume) async {
    final service = context.read<GlobalAudioService>();
    await service.setVolume(item.audioPath, volume);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF942F67),
        onPressed: () {
          final audioService = context.read<GlobalAudioService>();

          final currentItems =
              audioItems
                  .where((item) => audioService.isPlaying(item.audioPath))
                  .map(
                    (item) => FavouriteItem(
                      audioPath: item.audioPath,
                      volume: audioService.volume(item.audioPath),
                    ),
                  )
                  .toList();

          if (currentItems.isNotEmpty) {
            final nameController = TextEditingController();

            showDialog(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  title: const Text("Name your favourite"),
                  content: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: "e.g., Rain & Frogs",
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        if (name.isNotEmpty) {
                          // Use dialogContext to read provider
                          dialogContext.read<FavouritesService>().addFavourite(
                            FavouriteSet(name: name, items: currentItems),
                          );
                          Navigator.of(dialogContext).pop();
                        }
                      },
                      child: const Text("Save"),
                    ),
                  ],
                );
              },
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No sounds are currently playing.")),
            );
          }
        },
        child: const Icon(Icons.favorite),
      ),
      body: Consumer<GlobalAudioService>(
        builder: (context, audioService, _) {
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: audioItems.length,
            itemBuilder: (context, index) {
              final item = audioItems[index];
              final isPlaying = audioService.isPlaying(item.audioPath);
              final volume = audioService.volume(item.audioPath);

              return Card(
                elevation: 4,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => togglePlay(item),
                      child: ColorFiltered(
                        colorFilter:
                            isPlaying
                                ? const ColorFilter.mode(
                                  Colors.transparent,
                                  BlendMode.multiply,
                                )
                                : const ColorFilter.matrix([
                                  0.2126,
                                  0.7152,
                                  0.0722,
                                  0,
                                  0,
                                  0.2126,
                                  0.7152,
                                  0.0722,
                                  0,
                                  0,
                                  0.2126,
                                  0.7152,
                                  0.0722,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  1,
                                  0,
                                ]),
                        child: Image.asset(
                          item.imagePath,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              item.displayName,
                              style: GoogleFonts.comfortaa(fontSize: 20),
                            ),
                          ),
                          if (isPlaying)
                            Slider(
                              value: volume,
                              onChanged: (v) => changeVolume(item, v),
                              min: 0.0,
                              max: 1.0,
                              activeColor: const Color(0xFF942F67),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
