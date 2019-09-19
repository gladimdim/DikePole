import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locadeserta/creator/story/story.dart';
import 'package:locadeserta/models/Auth.dart';

final Firestore storage = Firestore.instance;

class StoryPersistence {
  StoryPersistence._internal();

  static final StoryPersistence instance = StoryPersistence._internal();

  Future<List<Story>> getUserStories(User user) async {
    try {
      var stories =
      await storage.collection("user_stories").document(user.uid).collection(
          "stories").getDocuments();
      List parsedStories = stories.documents.map((document) {
        Story story = Story.fromJson(document.data["storyjson"]);
        return story;
      }).toList();

      return parsedStories;
    } catch (e) {
      print('Exception while calling getUserStories: $e');
    }
    return null;
  }

  deleteStory(User user, Story story) async {
    return await storage
        .collection("user_stories")
        .document(user.uid)
        .collection("stories")
        .document(story.title)
        .delete();
  }

  writeStory(User user, Story story) async {
    DocumentSnapshot doc = await storage
        .collection("user_stories")
        .document(user.uid)
        .collection("stories")
        .document(story.title)
        .get();

    var data = {"storyjson": story.toJson()};
    if (doc.exists) {
      storage.document(doc.reference.path).updateData(data);
    } else {
      storage.document(doc.reference.path).setData(data);
    }
  }
}