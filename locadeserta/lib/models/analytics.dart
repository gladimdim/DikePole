import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locadeserta/creator/story/story.dart';

final Firestore storage = Firestore.instance;

class Analytics {
  Analytics._internal();

  static final Analytics instance = Analytics._internal();

  Future addStoryToLog(Story story) async {
    DocumentSnapshot doc = await storage
        .document("/storylog/${DateTime.now().toString()}")
        .get();

    var data = {"title": story.title, "history": story.history.map((element) => element.toMap()).toList()};
    return await storage.document(doc.reference.path).setData(data);
  }
}