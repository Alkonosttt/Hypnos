// for ChangeNotifier
import 'package:flutter/material.dart';
// for FavouriteSet
import 'package:hypnos/models/favouritesmodels.dart';

class FavouritesService extends ChangeNotifier {
  List<FavouriteSet> _favourites = [];

  List<FavouriteSet> get favourites => _favourites;

  void addFavourite(FavouriteSet set) {
    _favourites.add(set);
    notifyListeners();
  }

  void removeFavourite(int index) {
    _favourites.removeAt(index);
    notifyListeners();
  }

  void updateFavourite(int index, FavouriteSet updatedSet) {
    _favourites[index] = updatedSet;
    notifyListeners();
  }
}
