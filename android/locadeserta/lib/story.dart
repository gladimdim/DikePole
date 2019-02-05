class NextStory {
  final String pid;
  final String name;

  NextStory({this.pid, this.name});

  factory NextStory.fromJson(Map<String, dynamic> inputNext) {
    return NextStory(pid: inputNext["pid"], name: inputNext["name"]);
  }
}

class StoryNode {
  final String text;
  final String pid;
  final String background;
  final List<NextStory> links;

  StoryNode({this.text, this.pid, this.background, this.links});

  factory StoryNode.fromJson(Map<String, dynamic> map) {
    final inputLinks = map["links"] as List;

    final links = new List<NextStory>();
    if (inputLinks != null) {
      links.addAll(inputLinks.map((i) => NextStory.fromJson(i)).toList());
    }
    return StoryNode(text: map["text"],
        pid: map["pid"],
        background: map["backgorund"],
        links: links);
  }
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

  factory Story.fromJson(Map<String, dynamic> map) {
    List<StoryNode> nodes = new List();
    var input = map["passages"];
    for (var node in input) {
      nodes.add(StoryNode.fromJson(node));
    }
    return Story(
        current: "1",
        passages: nodes
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "passages": passages
      };
}
