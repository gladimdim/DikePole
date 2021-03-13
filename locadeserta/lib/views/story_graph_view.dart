import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart' as gse;
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/creator/components/edit_node_sequence_view.dart';
import 'package:locadeserta/models/story_persistence.dart';

class StoryTreeView extends StatefulWidget {
  final gse.Story story;

  StoryTreeView({required this.story});

  @override
  _StoryTreeViewState createState() => _StoryTreeViewState();
}

class _StoryTreeViewState extends State<StoryTreeView> {
  TreeController _controller = TreeController(allNodesExpanded: false);
  double iconSize = 24;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: generateTree(widget.story),
      ),
    );
  }

  TreeView generateTree(gse.Story story) {
    return TreeView(
      treeController: _controller,
      nodes: processPage(story.currentPage, story),
    );
  }

  List<TreeNode> processPage(gse.Page page, gse.Story story) {
    page.currentIndex = 0;
    List<TreeNode> content = List.empty(growable: true);
    while (story.canContinue()) {
      var node = page.getCurrentNode();

      content.add(
        TreeNode(
          content: storyNodeToGraphNode(node, widget.story.currentPage),
        ),
      );
      story.currentPage.nextNode();
    }
    // add last node in page
    try {
      content.add(
        TreeNode(
            content: storyNodeToGraphNode(
                page.getCurrentNode(), widget.story.currentPage)),
      );
    } catch (e) {}
    // add interactive options
    // and recursively process the "story flow"
    if (page.hasNext()) {
      var options = page.getNextNodeTexts();
      options.forEach((option) {
        var savedPage = story.currentPage;
        story.goToNextPageByText(option);
        content.add(
          TreeNode(
            content: Text(option!),
            children: processPage(story.currentPage, story),
          ),
        );
        story.currentPage = savedPage;
      });
    }

    if (story.currentPage.isTheEnd()) {
      content.add(TreeNode(content: theEndNode(story)));
    }

    return content;
  }

  Widget theEndNode(gse.Story story) {
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
    var max = 60;
    var length = str.length > max ? max : str.length;
    return str.substring(0, length) + (length < max ? "" : "...");
  }

  storyNodeToGraphNode(gse.PageNode node, gse.Page page) {
    var hasImage = node.imageType != null;
    var index = page.nodes.indexOf(node);
    return InkWell(
      child: Wrap(
        children: [
          if (hasImage)
            Icon(
              Icons.image,
              size: iconSize,
            ),
          Text(firstWords(node.text!)),
        ],
      ),
      onTap: () async {
        page.currentIndex = index;
        await Navigator.pushNamed(
          context,
          ExtractEditPassageView.routeName,
          arguments: EditPassageViewArguments(
            page: page,
          ),
        );

        await StoryPersistence.instance.writeStory(widget.story);
        setState(() {});
      },
    );
  }

  borderedText(String text) {
    return BorderedContainer(child: Text(text));
  }
}
