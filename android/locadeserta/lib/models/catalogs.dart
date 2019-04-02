import 'package:cloud_firestore/cloud_firestore.dart';

class Catalog {
  List<Story> stories;
}

class Story {
  final String title;
  final String description;
  final String inkJson;
  final DocumentReference documentReference;


  Story({this.title, this.description, this.inkJson, this.documentReference});

  Story.fromMap(Map<String, dynamic> map, {this.documentReference})
      : title = map['title'], description = map['description'], inkJson = map['inkjson'];

  Story.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data, documentReference: snapshot.reference);

}