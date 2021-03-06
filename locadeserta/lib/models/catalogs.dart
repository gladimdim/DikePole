class Catalog {
  List<CatalogStory> stories = List.empty(growable: true);
}

class CatalogStory {
  final String title;
  final String description;
  final String author;
  final String storyPath;
  final String year;

  CatalogStory({
    required this.title,
    required this.description,
    required this.author,
    required this.storyPath,
    required this.year,
  });

  CatalogStory.fromJson(Map<String, dynamic> map)
      : title = map['title'],
        description = map['description'],
        author = map["author"],
        year = map["year"],
        storyPath = map["storyPath"];
}
