import 'package:cloud_firestore/cloud_firestore.dart';

import 'Auth.dart';

class Catalog {
  List<CatalogStory> stories;
}

class CatalogStory {
  final String title;
  final String description;
  final String inkJson;
  final DocumentReference documentReference;
  final String id;
  final String author;

  CatalogStory({this.title, this.description, this.inkJson, this.documentReference, this.id, this.author});

  CatalogStory.fromMap(Map<String, dynamic> map, {this.documentReference})
      : title = map['title'], description = map['description'], inkJson = map['inkjson'], id = documentReference.documentID, author = map["author"];

  CatalogStory.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data, documentReference: snapshot.reference);

  static Future<CatalogStory> getStoryById(String id) async {
    var possibleStory = Firestore.instance.collection('catalog').document(id);
    var document = await possibleStory.get();
    return CatalogStory.fromSnapshot(document);
  }

  static Future<CatalogStory> getCatalogStoryForUser(User user) async {
    QuerySnapshot a = await Firestore.instance
        .collection("user_states")
        .document(user.uid)
        .collection("states").getDocuments();

    String s = a.documents[0]["catalogidreference"];

    return await CatalogStory.getStoryById(s);
  }
}