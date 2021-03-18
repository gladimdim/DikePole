import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart' as gse;
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/creator/components/edit_node_sequence_view.dart';
import 'package:locadeserta/models/background_image.dart';
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
      if (node != null) {
        content.add(
          TreeNode(
            content: storyNodeToGraphNode(node, widget.story.currentPage),
          ),
        );
      }
      story.currentPage.nextNode();
    }
    // add last node in page
    var lastNode = page.getCurrentNode();
    if (lastNode != null) {
      content.add(
        TreeNode(
            content: storyNodeToGraphNode(lastNode, widget.story.currentPage)),
      );
    }
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
    return BorderedContainer(
      child: InkWell(
        onTap: () async {
          var nodeIndex = page.nodes.indexOf(node);
          page.currentIndex = nodeIndex;
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
        child: Row(
          children: [
            node.imageType == null
                ? Icon(
                    Icons.texture,
                  )
                : Image(
                    image:
                        BackgroundImage.getAssetImageForType(node.imageType!),
                    width: 32,
                  ),
            Text(node.text!,
                style: Theme.of(context).textTheme.headline6,
                maxLines: 20,
                softWrap: false,
                overflow: TextOverflow.fade),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                setState(() {
                  page.removeNode(node);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  borderedText(String text) {
    return BorderedContainer(child: Text(text));
  }
}
