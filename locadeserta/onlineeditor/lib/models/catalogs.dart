import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;

fs.Firestore storage = fb.firestore();

class Catalog {
  List<CatalogStory> stories;
}

class CatalogStory {
  final String title;
  final String description;
  final String id;
  final String author;
  final String gladJson;
  final String year;

  CatalogStory(
      {this.title,
      this.description,
      this.id,
      this.author,
      this.gladJson,
      this.year});

  CatalogStory.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        description = map['description'],
        id = map['title'],
        author = map["author"],
        year = map["year"],
        gladJson = map["gladJson"];

  static Future<List<CatalogStory>> getAvailableCatalogStories(
      String locale) async {
    try {
      fs.QuerySnapshot stories =
          await fb.firestore().collection("catalogs/$locale/stories").get();
      List parsedStories = stories.docs.map((document) {
        CatalogStory story = CatalogStory.fromMap(document.data());
        return story;
      }).toList();

      return parsedStories;
    } catch (e) {
      print('Exception while calling getUserStories: $e');
    }
    return null;
  }
}
