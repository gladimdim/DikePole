// import 'package:flutter/material.dart';
// import 'package:gladstoriesengine/gladstoriesengine.dart';
// import 'package:graphview/GraphView.dart';
// import 'package:locadeserta/components/bordered_container.dart';

// class StoryGraphView extends StatefulWidget {
//   final Story story;

//   StoryGraphView({required this.story});

//   @override
//   _StoryGraphViewState createState() => _StoryGraphViewState();
// }

// class _StoryGraphViewState extends State<StoryGraphView> {
//   Graph graph = Graph();
//   double iconSize = 24;

//   BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration()
//     ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM)
//     ..siblingSeparation = (10)
//     ..levelSeparation = (10)
//     ..subtreeSeparation = (10);

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           GraphView(
//             graph: renderStoryGraph(widget.story),
//             algorithm:
//                 BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
//             paint: Paint()
//               ..color = Colors.green
//               ..strokeWidth = 1
//               ..style = PaintingStyle.stroke,
//           ),
//         ],
//       ),
//     );
//   }

//   Graph renderStoryGraph(Story story) {
//     story.reset();
//     var graph = Graph();
//     generateNextNode(graph, null, story);

//     return graph;
//   }

//   void generateNextNode(Graph graph, Node parent, Story story) {
//     var node = Node(storyNodeToGraphNode(story.currentPage.getCurrentNode()));
//     if (parent == null) {
//       graph.addNode(node);
//     } else {
//       graph.addEdge(parent, node);
//     }
//     if (story.canContinue()) {
//       story.currentPage.nextNode();
//       generateNextNode(graph, node, story);
//     } else if (story.currentPage.isTheEnd()) {
//       graph.addEdge(node, Node(theEndNode(story)));
//     } else {
//       var savedPage = story.currentPage;
//       var options = story.currentPage.next;
//       options.forEach((option) {
//         var optionNode = Node(borderedText(option.text));
//         graph.addEdge(node, optionNode);
//         story.goToNextPage(option);
//         generateNextNode(graph, optionNode, story);
//         story.currentPage = savedPage;
//       });
//     }
//   }

//   theEndNode(Story story) {
//     var isAlive = story.currentPage.endType == EndType.ALIVE;
//     return Wrap(
//       children: [
//         if (isAlive)
//           Icon(
//             Icons.person,
//             size: iconSize,
//           ),
//         if (!isAlive)
//           Icon(
//             Icons.person_add_disabled_rounded,
//             size: iconSize,
//           ),
//         borderedText("THE END"),
//       ],
//     );
//   }

//   firstWords(String str) {
//     var max = 20;
//     var length = str.length > max ? max : str.length;
//     return str.substring(0, length);
//   }

//   storyNodeToGraphNode(PageNode node) {
//     var hasImage = node.imageType != null;
//     return Wrap(
//       children: [
//         if (hasImage)
//           Icon(
//             Icons.image,
//             size: iconSize,
//           ),
//         borderedText(node.text),
//       ],
//     );
//   }

//   borderedText(String text) {
//     return BorderedContainer(child: Text(firstWords(text)));
//   }
// }
