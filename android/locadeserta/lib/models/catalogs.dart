import 'package:cloud_firestore/cloud_firestore.dart';

class Catalog {
  List<CatalogStory> stories;
}

class CatalogStory {
  final String title;
  final String description;
  final String inkJson;
  final DocumentReference documentReference;

  CatalogStory({this.title, this.description, this.inkJson, this.documentReference});

  CatalogStory.fromMap(Map<String, dynamic> map, {this.documentReference})
      : title = map['title'], description = map['description'], inkJson = map['inkjson'];

  CatalogStory.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data, documentReference: snapshot.reference);

}