import 'package:flutter/material.dart';
import 'package:hypnos/services/globalaudioplayerservice.dart';
import 'package:hypnos/models/favouritesmodels.dart';

class FavouritePlayScreen extends StatelessWidget {
  final FavouriteSet set;

  const FavouritePlayScreen({super.key, required this.set});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(set.name)),
      body: ListView(
        children:
            set.items.map((item) {
              final isPlaying = GlobalAudioService().isPlaying(item.audioPath);
              final volume = GlobalAudioService().volume(item.audioPath);

              return Column(
                children: [
                  ListTile(
                    title: Text(item.audioPath.split('/').last),
                    trailing: IconButton(
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: () {
                        if (isPlaying) {
                          GlobalAudioService().pause(item.audioPath);
                        } else {
                          GlobalAudioService().play(
                            item.audioPath,
                            volume: item.volume,
                          );
                        }
                      },
                    ),
                  ),
                  Slider(
                    value: volume,
                    onChanged: (v) {
                      GlobalAudioService().setVolume(item.audioPath, v);
                    },
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}
