import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// for watch and read
import 'package:provider/provider.dart';
import 'package:hypnos/services/favouritesservice.dart';
import 'package:hypnos/screens/favouriteplayscreen.dart';
// for a map of display- and file names
import 'package:hypnos/constants/displaynames.dart';

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
