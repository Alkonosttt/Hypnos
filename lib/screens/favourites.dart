import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// for watch and read
import 'package:provider/provider.dart';
import 'package:hypnos/services/favouritesservice.dart';
import 'package:hypnos/screens/favouriteplayscreen.dart';

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
                      children:
                          fav.items.map((item) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.audioPath
                                      .split('/')
                                      .last
                                      .replaceAll('.mp3', ''),
                                ),
                                Slider(
                                  value: item.volume,
                                  onChanged: null, // preview only
                                  min: 0.0,
                                  max: 1.0,
                                ),
                              ],
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
