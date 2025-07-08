import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// for watch and read
import 'package:provider/provider.dart';
import 'package:hypnos/services/favouritesservice.dart';
import 'package:hypnos/screens/favouriteplayscreen.dart';

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

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favourites = context.watch<FavouritesService>().favourites;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 70, 0, 50),
            child: Text(
              'Favourites',
              style: GoogleFonts.caesarDressing(fontSize: 45),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: favourites.length,
              itemBuilder: (context, index) {
                final fav = favourites[index];
                return Card(
                  child: ListTile(
                    title: Text(fav.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          fav.items.map((item) {
                            return Text(
                              displayNames[item.audioPath.split('/').last] ??
                                  item.audioPath
                                      .split('/')
                                      .last
                                      .replaceAll('.mp3', ''),
                              style: TextStyle(fontSize: 14),
                            );
                          }).toList(),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // open edit dialog or screen
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            context.read<FavouritesService>().removeFavourite(
                              index,
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FavouritePlayScreen(set: fav),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
