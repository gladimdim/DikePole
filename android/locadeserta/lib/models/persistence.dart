import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import "package:locadeserta/models/story_bridge.dart";

import 'Auth.dart';
import 'catalogs.dart';

final Firestore storage = Firestore.instance;

class Persistence {
  Persistence._internal();

  static final Persistence instance = Persistence._internal();

  Future<String> getStateJsonFromBridge(StoryBridge bridge) async {
    return await bridge.getStateJson();
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

  Future<List<CatalogStory>> getAvailableCatalogStories(String locale) async {
    QuerySnapshot stories = await storage.collection("catalogs/$locale/stories").getDocuments();

    return stories.documents.map((snapshot) => CatalogStory.fromSnapshot(snapshot)).toList();
  }

  Future saveStateToStorageForUser(User user, CatalogStory catalogStory, StoryBridge bridge) async {
    String stateJson = await getStateJsonFromBridge(bridge);

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
