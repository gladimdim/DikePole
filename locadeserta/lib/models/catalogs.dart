import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locadeserta/models/Auth.dart';

class Catalog {
  List<CatalogStory> stories;
}

class CatalogStory {
  final String title;
  final String description;
  final DocumentReference documentReference;
  final String id;
  final String author;
  final String gladJson;
  final String year;

  CatalogStory({
    this.title,
    this.description,
    this.documentReference,
    this.id,
    this.author,
    this.gladJson,
    this.year,
  });

  CatalogStory.fromMap(Map<String, dynamic> map, {this.documentReference})
      : title = map['title'],
        description = map['description'],
        id = documentReference.documentID,
        author = map["author"],
        year = map["year"],
        gladJson = map["gladJson"];

  CatalogStory.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, documentReference: snapshot.reference);

  static Future<CatalogStory> getStoryById(String id) async {
    var possibleStory = Firestore.instance.collection('catalog').document(id);
    var document = await possibleStory.get();
    return CatalogStory.fromSnapshot(document);
  }

  static Future<CatalogStory> getCatalogStoryForUser(User user) async {
    QuerySnapshot a = await Firestore.instance
        .collection("user_states")
        .document(user.uid)
        .collection("states")
        .getDocuments();

    String s = a.documents[0]["catalogidreference"];

    return await CatalogStory.getStoryById(s);
  }

  static Future<List<CatalogStory>> getAvailableCatalogStories(
      String locale) async {
    QuerySnapshot stories;
    try {
      stories = await Firestore.instance
          .collection("catalogs/$locale/stories")
          .getDocuments();
    } catch (e) {
      print("exception: $e");
    }
    return stories.documents
        .map((snapshot) => CatalogStory.fromSnapshot(snapshot))
        .toList();
  }
}
