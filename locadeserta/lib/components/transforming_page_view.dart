import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/catalog_view.dart';
import 'package:locadeserta/models/catalogs.dart';

class TransformingPageView extends StatefulWidget {
  final Axis scrollDirection;
  final List<CatalogStory> stories;
  final Function(CatalogStory story) onStorySelected;

  TransformingPageView({
    this.scrollDirection = Axis.vertical,
    @required this.onStorySelected,
    this.stories,
  });

  @override
  _TransformingPageViewState createState() => _TransformingPageViewState();
}

class _TransformingPageViewState extends State<TransformingPageView> {
  double currentPage = 0.0;
  PageController _pageController;

  void _onScroll() {
    setState(() {
      currentPage = _pageController.page;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.7)
      ..addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: widget.scrollDirection,
      controller: _pageController,
      itemCount: widget.stories.length,
      itemBuilder: (context, index) {
        if (index == currentPage.floor()) {
          return Transform.translate(
            offset: Offset(100 * (currentPage - index.toDouble()), 0),
            child: _buildStoryShell(
                widget.stories[index], currentPage - index.toDouble()),
          );
        } else if (index >= currentPage.floor() + 1) {
          return Transform.translate(
            offset: Offset(100 * (index.toDouble() - currentPage), 0),
            child: _buildStoryShell(
                widget.stories[index], currentPage - index.toDouble()),
          );
        } else if (index <= currentPage.floor() - 1) {
          return Transform.translate(
            offset: Offset(100 * (currentPage - index.toDouble()), 0),
            child: _buildStoryShell(
                widget.stories[index], currentPage - index.toDouble()),
          );
        } else {
          return _buildStoryShell(
              widget.stories[index], index.toDouble() - currentPage);
        }
      },
    );
  }

  Widget _buildStoryShell(CatalogStory story, double value) {
    return Center(
      child: CatalogView(
        catalogStory: story,
//        animationValue: value,
        onReadPressed: () => widget.onStorySelected(story),
        onDetailPressed: () {
          Navigator.pushNamed(
            context,
            "/story_details",
            arguments: CatalogViewArguments(
              expanded: true,
              catalogStory: story,
              onReadPressed: () => widget.onStorySelected(story),
              onDetailPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
