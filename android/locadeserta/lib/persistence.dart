import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:locadeserta/models/story_bridge.dart";

import 'models/Auth.dart';
import 'models/catalogs.dart';

final Firestore storage = Firestore.instance;

class Persistence {
  static Future<String> getStateJsonFromBridge(StoryBridge bridge) async {
    return await bridge.getStateJson();
  }

  static Future<CatalogStory> getCatalogStoryById(String id) async {
    return await CatalogStory.getStoryById(id);
  }

  static Future<String> getStateJsonForUserAndCatalog(
      User user, CatalogStory catalogStory) async {
    CollectionReference collection = _getUserStateReferences(user);
    DocumentSnapshot doc = await collection.document(catalogStory.id).get();

    if (doc.exists) {
      return doc["statejson"];
    } else {
      return null;
    }
  }

  static CollectionReference _getUserStateReferences(User user) {
    return storage
        .collection("user_states")
        .document(user.uid)
        .collection("states");
  }

  static Future<DocumentReference> _getUserStatesForCatalog(
      User user, CatalogStory catalogStory) async {
    Query query = _getUserStateReferences(user)
        .where("catalogidreference", isEqualTo: catalogStory.id);
    QuerySnapshot qs = await query.getDocuments();
    return qs.documents[0].reference;
  }

  static Future saveStateToStorageForUser(User user, CatalogStory catalogStory, StoryBridge bridge) async {
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
