import 'package:flutter/material.dart';
import 'package:hypnos/services/globalaudioplayerservice.dart';
import 'package:hypnos/models/favouritesmodels.dart';
import 'package:provider/provider.dart';
import 'package:hypnos/services/favouritesservice.dart';

// TODO: move this to a separate file and import it
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

class FavouritePlayScreen extends StatefulWidget {
  final FavouriteSet set;

  const FavouritePlayScreen({super.key, required this.set});

  @override
  State<FavouritePlayScreen> createState() => _FavouritePlayScreenState();
}

class _FavouritePlayScreenState extends State<FavouritePlayScreen> {
  late Map<String, double> volumeMap;

  @override
  void initState() {
    super.initState();
    volumeMap = {
      for (var item in widget.set.items)
        item.audioPath: GlobalAudioService().volume(item.audioPath),
    };
  }

  void playAll() {
    for (var item in widget.set.items) {
      GlobalAudioService().play(
        item.audioPath,
        volume: volumeMap[item.audioPath]!,
      );
    }
    setState(() {});
  }

  void pauseAll() {
    for (var item in widget.set.items) {
      GlobalAudioService().pause(item.audioPath);
    }
    setState(() {});
  }

  bool anyIsPlaying() {
    return widget.set.items.any(
      (item) => GlobalAudioService().isPlaying(item.audioPath),
    );
  }

  void removeItem(int index) {
    setState(() {
      final removedItem = widget.set.items.removeAt(index);
      volumeMap.remove(removedItem.audioPath);
    });

    // persist change
    final service = context.read<FavouritesService>();
    final setIndex = service.favourites.indexOf(widget.set);
    if (setIndex != -1) {
      service.updateFavourite(setIndex, widget.set);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAnyPlaying = anyIsPlaying();

    return Scaffold(
      appBar: AppBar(title: Text(widget.set.name)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              icon: Icon(isAnyPlaying ? Icons.pause : Icons.play_arrow),
              label: Text(isAnyPlaying ? 'Pause All' : 'Play All'),
              onPressed: () {
                if (isAnyPlaying) {
                  pauseAll();
                } else {
                  playAll();
                }

                // delay rebuild to reflect audio state
                Future.delayed(Duration(milliseconds: 200), () {
                  setState(() {});
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.set.items.length,
              itemBuilder: (context, index) {
                final item = widget.set.items[index];
                final isPlaying = GlobalAudioService().isPlaying(
                  item.audioPath,
                );
                final filename = item.audioPath.split('/').last;
                final display =
                    displayNames[filename] ?? filename.replaceAll('.mp3', '');

                return Column(
                  children: [
                    ListTile(
                      title: Text(display),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                            onPressed: () {
                              if (isPlaying) {
                                GlobalAudioService().pause(item.audioPath);
                              } else {
                                GlobalAudioService().play(
                                  item.audioPath,
                                  volume: volumeMap[item.audioPath]!,
                                );
                              }

                              Future.delayed(Duration(milliseconds: 200), () {
                                setState(() {});
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => removeItem(index),
                          ),
                        ],
                      ),
                    ),
                    Slider(
                      value: volumeMap[item.audioPath]!,
                      onChanged: (v) {
                        setState(() {
                          volumeMap[item.audioPath] = v;
                          GlobalAudioService().setVolume(item.audioPath, v);
                        });
                      },
                      min: 0.0,
                      max: 1.0,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
