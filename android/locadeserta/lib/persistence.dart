import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:locadeserta/models/story_bridge.dart";

import 'models/Auth.dart';
import 'models/catalogs.dart';

class Persistence {
  final StoryBridge bridge;
  final Firestore storage;

  Persistence({this.bridge, @required this.storage});

  Future<String> getStateJson() async {
    return await this.bridge.getStateJson();
  }

  Future<CatalogStory> getCatalogStoryById(String id) async {
    return await CatalogStory.getStoryById(id);
  }

  Future<String> getStateJsonForUserAndCatalog(
      User user, CatalogStory catalogStory) async {
    CollectionReference collection = _getUserStateReferences(user);
    DocumentSnapshot doc = await collection.document(catalogStory.id).get();

    if (doc.exists) {
      return doc["statejson"];
    } else {
      return null;
    }
  }

  CollectionReference _getUserStateReferences(User user) {
    return storage
        .collection("user_states")
        .document(user.uid)
        .collection("states");
  }

  Future<DocumentReference> _getUserStatesForCatalog(
      User user, CatalogStory catalogStory) async {
    Query query = _getUserStateReferences(user)
        .where("catalogidreference", isEqualTo: catalogStory.id);
    QuerySnapshot qs = await query.getDocuments();
    return qs.documents[0].reference;
  }

  Future saveStateToStorageForUser(User user, CatalogStory catalogStory) async {
    String stateJson = await getStateJson();

    DocumentSnapshot doc = await storage
        .collection("user_states")
        .document(user.uid)
        .collection("states")
        .document(catalogStory.id)
        .get();

    Map<String, dynamic> toAdd = {
      "catalogidreference": catalogStory.id,
      "statejson": stateJson,
    };
    if (doc.exists) {
      storage.document(doc.reference.path).updateData(toAdd);
    } else {
      storage.document(doc.reference.path).setData(toAdd);
    }
  }
}
