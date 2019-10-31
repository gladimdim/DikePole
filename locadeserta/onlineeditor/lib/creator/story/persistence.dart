import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;
import 'package:onlineeditor/creator/story/story.dart';
import 'package:onlineeditor/models/LDUser.dart';

fs.Firestore storage = fb.firestore();

class StoryPersistence {
  StoryPersistence._internal();

  static final StoryPersistence instance = StoryPersistence._internal();

  Future<List<Story>> getUserStories(LDUser user) async {
    try {
      fs.QuerySnapshot stories = await fb
          .firestore()
          .collection("user_stories/${user.uid}/stories")
          .get();
      List parsedStories = stories.docs.map((document) {
        Story story = Story.fromJson(document.data()["storyjson"]);
        return story;
      }).toList();

      return parsedStories;
    } catch (e) {
      print('Exception while calling getUserStories: $e');
    }
    return null;
  }

  writeStory(LDUser user, Story story) async {
    fs.DocumentSnapshot doc = await storage
        .doc("user_stories/${user.uid}/stories/${story.title}")
        .get();

    var data = {"storyjson": story.toJson()};
    if (doc.exists) {
      storage.doc(doc.ref.path).update(data: data);
    } else {
      storage.doc(doc.ref.path).set(data);
    }
  }

  Future deleteStory(LDUser user, Story story) async {
    return await storage
        .doc("user_stories/${user.uid}/stories/${story.title}").delete();
  }
}
