class NextStory {
  final String pid;
  final String name;

  NextStory({this.pid, this.name});
}

class StoryNode {
  final String text;
  final String pid;
  final String background;
  final List<NextStory> links;
  StoryNode({this.text, this.pid, this.background, this.links});
}

class Story {
  final String current;
  final List<StoryNode> passages;
  Story({this.passages, this.current = "1"});

  StoryNode getCurrentStory() {
    return this.passages.where((story) {
      return story.pid == current;
    }).elementAt(0);
  }

  StoryNode getStoryForPid(String pid) {
    return this.passages.where((story) {
      return story.pid == pid;
    }).elementAt(0);
  }

  Map<String, dynamic> toJson() => {
    "passages": passages
  };
}