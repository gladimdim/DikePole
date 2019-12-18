import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;
import 'package:locadeserta/models/Auth.dart';

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
  final fs.DocumentReference documentReference;

  CatalogStory(
      {this.title,
      this.description,
      this.id,
      this.author,
      this.gladJson,
      this.documentReference,
      this.year});

  CatalogStory.fromMap(Map<String, dynamic> map, {this.documentReference})
      : title = map['title'],
        description = map['description'],
        author = map["author"],
        id = "0",
        year = map["year"],
        gladJson = map["gladJson"];

  CatalogStory.fromSnapshot(fs.DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), documentReference: snapshot.ref);

  static Future<CatalogStory> getCatalogStoryForUser(User user) async {
    fs.QuerySnapshot a =
        await storage.collection("user_states/${user.uid}/states").get();

    String s = a.docs[0].data()["catalogidreference"];

    return await CatalogStory.getStoryById(s);
  }

  static Future<List<CatalogStory>> getAvailableCatalogStories(
      String locale) async {
    try {
      fs.QuerySnapshot stories =
          await storage.collection("catalogs/$locale/stories").get();
      List parsedStories = stories.docs.map((document) {
        CatalogStory story = CatalogStory.fromMap(document.data());
        return story;
      }).toList();

      return parsedStories;
    } catch (e) {
      print('Exception while calling getAvailableCatalogStories: $e');
    }
    return null;
  }

  static Future<CatalogStory> getStoryById(String id) async {
    var possibleStory = await storage.collection('catalog/$id').get();
    return CatalogStory.fromSnapshot(possibleStory.docs[0]);
  }
}
