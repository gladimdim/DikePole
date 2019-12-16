import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;
import 'package:gladstoriesengine/gladstoriesengine.dart';

fs.Firestore storage = fb.firestore();

class Analytics {
  Analytics._internal();

  static final Analytics instance = Analytics._internal();

  Future addStoryToLog(Story story) async {
    fs.DocumentSnapshot doc = await storage
        .doc("/storylog/${DateTime.now().toString()}")
        .get();

    var data = {"title": story.title, "history": story.history.map((element) => element.toMap()).toList()};
    return await storage.doc(doc.ref.path).set(data);
  }
}