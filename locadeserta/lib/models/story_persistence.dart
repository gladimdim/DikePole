import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart' as gse;
import 'package:locadeserta/loaders/catalogs.dart';
import 'package:locadeserta/models/app_preferences.dart';
import 'package:locadeserta/models/background_image.dart';

class StoryPersistence {
  StoryPersistence._internal();
  static final StoryPersistence instance = StoryPersistence._internal();

  Future<List<gse.Story>> getCreatorStories() async {
    try {
      var stories = await AppPreferences.instance.getCreatorStories();
      List parsedStories = stories.map((document) {
        gse.Story story = gse.Story.fromJson(document,
            imageResolver: BackgroundImage.getRandomImageForType);
        return story;
      }).toList();

      return parsedStories;
    } catch (e) {
      print('Exception while calling getUserStories: $e');
    }
    return null;
  }

  Future<List<CatalogStory>> getCatalogStories(BuildContext context) async {
    try {
      var stories = await getCatalogStoriesJsons(context);
      List<CatalogStory> parsedStories =
          (stories['stories'] as List).map((document) {
        CatalogStory catalogStory = CatalogStory.fromJson(document);
        return catalogStory;
      }).toList();

      return parsedStories;
    } catch (e) {
      print('Exception while calling get Catalog Stories: $e');
    }
    return null;
  }

  Future writeStoryWithState(gse.Story story) async {
    String jsonString = story.toStateJson();
    await AppPreferences.instance
        .saveStoryStringByName(story.title, jsonString);
    return true;
  }

  Future writeStory(gse.Story story) async {
    String jsonString = story.toJson();
    await AppPreferences.instance
        .saveStoryStringByName(story.title, jsonString);
    return true;
  }

  Future deleteStory(gse.Story story) async {
    // TODO:
  }

  Future<gse.Story> readyStoryByCatalog(
      BuildContext context, CatalogStory catalogStory) async {
    var storyString =
        await AppPreferences.instance.readStoryStringByName(catalogStory.title);
    if (storyString == null) {
      storyString = await DefaultAssetBundle.of(context)
          .loadString(catalogStory.storyPath);
    }

    gse.Story story = gse.Story.fromJson(storyString,
        imageResolver: BackgroundImage.getRandomImageForType);

    return story;
  }

  Future getCatalogStoriesJsons(BuildContext context) async {
    var catalogStories = await DefaultAssetBundle.of(context)
        .loadString('assets/story_catalog.json');
    return jsonDecode(catalogStories);
  }
}
