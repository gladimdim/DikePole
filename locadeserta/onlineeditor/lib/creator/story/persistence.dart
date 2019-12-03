import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:onlineeditor/models/LDUser.dart';
import 'package:onlineeditor/models/background_image.dart';
import 'package:onlineeditor/models/catalogs.dart';

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
        Story story = Story.fromJson(document.data()["storyjson"],
            imageResolver: BackgroundImage.getRandomImageForType);
        return story;
      }).toList();

      return parsedStories;
    } catch (e) {
      print('Exception while calling getUserStories: $e');
    }
    return null;
  }

  Future<Story> readyStoryStateById(LDUser user, CatalogStory story) async {
    fs.DocumentSnapshot doc = await storage
        .doc("user_states/${user.uid}/states/${story.title}")
        .get();

    if (doc.exists) {
      var state = doc.data()["gladJsonState"];
      var savedStory = Story.fromJson(state,
          imageResolver: BackgroundImage.getRandomImageForType);
      return savedStory;
    } else {
      print("doc does not exist");
      return Story.fromJson(story.gladJson,
          imageResolver: BackgroundImage.getRandomImageForType);
    }
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
        .doc("user_stories/${user.uid}/stories/${story.title}")
        .delete();
  }

  Future saveGladStoryToStorageForUser(LDUser user, Story story) async {
    fs.DocumentSnapshot doc = await storage
        .doc("user_states/${user.uid}/states/${story.title}")
        .get();

    Map<String, dynamic> toAdd = {
      "catalogidreference": story.title,
      "gladJsonState": story.toStateJson(),
    };
    if (doc.exists) {
      storage.doc(doc.ref.path).update(data: toAdd);
    } else {
      storage.doc(doc.ref.path).set(toAdd);
    }
  }
}
