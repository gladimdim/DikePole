import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locadeserta/creator/story/story.dart';
import 'package:locadeserta/creator/story/story_builder.dart';
import 'package:locadeserta/models/Auth.dart';

final Firestore storage = Firestore.instance;

class StoryPersistence {
  StoryPersistence._internal();

  static final StoryPersistence instance = StoryPersistence._internal();

  Future<List<StoryBuilder>> getUserStories(User user) async {
    var stories;
    List<StoryBuilder> result;
    try {
      stories =
      await storage.collection("user_stories").document(user.uid).collection(
          "stories").getDocuments();
      List parsedStories = stories.documents.map((document) {
        Story story = Story.fromJson(document.data["storyjson"]);
        return story;
      }).toList();

      result = parsedStories.map((story) =>
          StoryBuilder.fromStory(story)).toList();
    } catch (e) {
      print('Exception while calling getUserStories: $e');
    }
    return result;
  }

  deleteStory(User user, StoryBuilder storyBuilder) async {
    return await storage
        .collection("user_stories")
        .document(user.uid)
        .collection("stories")
        .document(storyBuilder.title)
        .delete();
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