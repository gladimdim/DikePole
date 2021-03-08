import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart' as gse;
import 'package:locadeserta/components/bordered_container.dart';

class StoryGraphView extends StatefulWidget {
  final gse.Story story;

  StoryGraphView({required this.story});

  @override
  _StoryGraphViewState createState() => _StoryGraphViewState();
}

class _StoryGraphViewState extends State<StoryGraphView> {
  double iconSize = 24;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: generateTree(widget.story));
  }

  TreeView generateTree(gse.Story story) {
    return TreeView(
      nodes: processPage(story.currentPage, story),
    );
  }

  List<TreeNode> processPage(gse.Page page, gse.Story story) {
    page.currentIndex = 0;
    List<TreeNode> content = List.empty(growable: true);
    List<TreeNode> children = List.empty(growable: true);
    while (story.canContinue()) {
      content.add(
        TreeNode(content: storyNodeToGraphNode(page.getCurrentNode())),
      );
      story.currentPage.nextNode();
    }

    // add last node in page
    content.add(
      TreeNode(content: storyNodeToGraphNode(page.getCurrentNode())),
    );

    // add options

    var options = page.getNextNodeTexts();

    options.forEach((option) {
      var savedPage = story.currentPage;
      story.goToNextPageByText(option);
      content.add(
        TreeNode(
          content: borderedText(option!),
          children: processPage(story.currentPage, story),
        ),
      );
      story.currentPage = savedPage;
    });

    return content;
  }

  // void generateNextNode(Graph graph, Node parent, Story story) {
  //   var node = Node(storyNodeToGraphNode(story.currentPage.getCurrentNode()));
  //   if (parent == null) {
  //     graph.addNode(node);
  //   } else {
  //     graph.addEdge(parent, node);
  //   }
  //   if (story.canContinue()) {
  //     story.currentPage.nextNode();
  //     generateNextNode(graph, node, story);
  //   } else if (story.currentPage.isTheEnd()) {
  //     graph.addEdge(node, Node(theEndNode(story)));
  //   } else {
  //     var savedPage = story.currentPage;
  //     var options = story.currentPage.next;
  //     options.forEach((option) {
  //       var optionNode = Node(borderedText(option.text));
  //       graph.addEdge(node, optionNode);
  //       story.goToNextPage(option);
  //       generateNextNode(graph, optionNode, story);
  //       story.currentPage = savedPage;
  //     });
  //   }
  // }

  theEndNode(gse.Story story) {
    var isAlive = story.currentPage.endType == gse.EndType.ALIVE;
    return Wrap(
      children: [
        if (isAlive)
          Icon(
            Icons.person,
            size: iconSize,
          ),
        if (!isAlive)
          Icon(
            Icons.person_add_disabled_rounded,
            size: iconSize,
          ),
        borderedText("THE END"),
      ],
    );
  }

  firstWords(String str) {
    var max = 20;
    var length = str.length > max ? max : str.length;
    return str.substring(0, length);
  }

  storyNodeToGraphNode(gse.PageNode node) {
    var hasImage = node.imageType != null;
    return Wrap(
      children: [
        if (hasImage)
          Icon(
            Icons.image,
            size: iconSize,
          ),
        borderedText(node.text!),
      ],
    );
  }

  borderedText(String text) {
    return BorderedContainer(child: Text(text));
  }
}
