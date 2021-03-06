import 'dart:convert';

class CatalogGladStory {
  final String title;
  final String description;
  final String author;
  final int settingYear;
  final String url;

  CatalogGladStory(
      {required this.title,
      required this.author,
      required this.description,
      required this.settingYear,
      required this.url});

  static CatalogGladStory fromJsonMap(Map map) {
    return CatalogGladStory(
        title: map["title"],
        description: map["description"],
        author: map["author"],
        url: map["url"],
        settingYear: map["settingYear"]);
  }

  static List<CatalogGladStory> fromJsonList(String input) {
    List list = jsonDecode(input);
    return List<CatalogGladStory>.from(
        list.map((str) => CatalogGladStory.fromJsonMap(str)));
  }
}
