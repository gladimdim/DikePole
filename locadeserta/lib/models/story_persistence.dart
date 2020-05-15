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
      var storiesString = await AppPreferences.instance.getCreatorStories();
      Map storiesList = jsonDecode(storiesString);
      List parsedStories = (storiesList as Map).keys.map((key) {
        gse.Story story = gse.Story.fromJson(storiesList[key],
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

  Future writeCreatorStory(gse.Story story) async {
    String jsonString = story.toJson();
    return await AppPreferences.instance
        .saveCreatorStory(story.title, jsonString);
  }

  Future<bool> deleteCreatorStory(gse.Story story) {
    return AppPreferences.instance.deleteCreatorStory(story.title);
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
