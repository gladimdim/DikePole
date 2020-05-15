class Catalog {
  List<CatalogStory> stories;
}

class CatalogStory {
  final String title;
  final String description;
  final String author;
  final String storyPath;
  final String year;

  CatalogStory({
    this.title,
    this.description,
    this.author,
    this.storyPath,
    this.year,
  });

  CatalogStory.fromJson(Map<String, dynamic> map)
      : title = map['title'],
        description = map['description'],
        author = map["author"],
        year = map["year"],
        storyPath = map["storyPath"];
}
