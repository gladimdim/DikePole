import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locadeserta/creator/story/story_builder.dart';
import 'package:locadeserta/models/Auth.dart';

final Firestore storage = Firestore.instance;

class StoryPersistence {
  StoryPersistence._internal();

  static final StoryPersistence instance = StoryPersistence._internal();

  getUserStories(User user) async {
    return await storage.collection("user_stories").document(user.uid).collection("stories").getDocuments();
  }

  writeStory(User user, StoryBuilder storyBuilder) async {

    DocumentSnapshot doc = await storage
        .collection("user_stories")
        .document(user.uid)
        .collection("stories")
        .document(storyBuilder.title)
        .get();

    var data = {"storyjson": storyBuilder.toModel().toJson()};
    if (doc.exists) {
      storage.document(doc.reference.path).updateData(data);
    } else {
      storage.document(doc.reference.path).setData(data);
    }
  }
}