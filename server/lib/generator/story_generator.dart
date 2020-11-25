import 'dart:io';

import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:server/constants.dart';
import 'package:server/generator/backend.dart';
import 'package:server/server.dart';

var builtinStories = "built_in_stories";

var counterMap = {};

void run() async {
  var stories = await fetchStories();
  await Future.forEach(stories, ((storyCatalog) async {
    var storyPath = urlAssets + "/" + storyCatalog["storyPath"];
    var story = await fetchStory(storyPath);
    var firstStory = Story.fromJson(story);
    await runStory(firstStory);
  }));
}

int getCounterForStory(String title) {
  var counter = counterMap[title] ?? -1;
  counter++;
  counterMap[title] = counter;
  return counterMap[title];
}

void runStory(Story story) async {
  if (story.canContinue()) {
    story.doContinue();
    runStory(story);
  } else {
    if (story.currentPage.isTheEnd()) {
      var file = await File(
              "$rootFolder/$builtinStories/${story.title}/${getCounterForStory(story.title)}.md")
          .create(recursive: true);
      await file.writeAsString(story.toMarkdownString(imagePrefix));
    } else {
      for (var optionText in story.currentPage.getNextNodeTexts()) {
        var newStory = Story.fromJson(story.toStateJson());
        newStory.goToNextPageByText(optionText);
        runStory(newStory);
      }
    }
  }
}
