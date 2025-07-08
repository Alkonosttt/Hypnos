import 'package:flutter/material.dart';
// global audio service
import 'package:hypnos/services/globalaudioplayerservice.dart';
import 'package:hypnos/models/favouritesmodels.dart';
import 'package:provider/provider.dart';
// favourites service
import 'package:hypnos/services/favouritesservice.dart';
import 'package:google_fonts/google_fonts.dart';
// for a map of display- and file names
import 'package:hypnos/constants/displaynames.dart';

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
      appBar: AppBar(
        title: Text(
          widget.set.name,
          style: GoogleFonts.comfortaa(color: Color(0xFF942F67)),
        ),
      ),
      body: Column(
        children: [
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
                      title: Text(display, style: GoogleFonts.comfortaa()),
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
                      activeColor: const Color(0xFF942F67),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF942F67),
                textStyle: GoogleFonts.comfortaa(),
              ),
              icon: Icon(isAnyPlaying ? Icons.pause : Icons.play_arrow),
              label: Text(isAnyPlaying ? 'pause all' : 'play all'),
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
        ],
      ),
    );
  }
}
