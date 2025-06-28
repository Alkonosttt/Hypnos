class FavouriteItem {
  final String audioPath;
  final double volume;

  FavouriteItem({required this.audioPath, required this.volume});

  // for saving/loading
  Map<String, dynamic> toJson() => {'audioPath': audioPath, 'volume': volume};

  factory FavouriteItem.fromJson(Map<String, dynamic> json) =>
      FavouriteItem(audioPath: json['audioPath'], volume: json['volume']);
}

class FavouriteSet {
  String name;
  List<FavouriteItem> items;

  FavouriteSet({required this.name, required this.items});

  Map<String, dynamic> toJson() => {
    'name': name,
    'items': items.map((item) => item.toJson()).toList(),
  };

  factory FavouriteSet.fromJson(Map<String, dynamic> json) => FavouriteSet(
    name: json['name'],
    items:
        (json['items'] as List<dynamic>)
            .map((e) => FavouriteItem.fromJson(e))
            .toList(),
  );
}
