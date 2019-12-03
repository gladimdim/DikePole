import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class TransformingPageView extends StatefulWidget {
  final List<Widget> pages;
  final Axis scrollDirection;

  TransformingPageView(
      {@required this.pages, this.scrollDirection = Axis.vertical});

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
      itemCount: widget.pages.length,
      itemBuilder: (context, index) {
        if (index == currentPage.floor()) {
          return Transform.translate(
            offset: Offset(100 * (currentPage - index.toDouble()), 0),
            child: widget.pages[index],
          );
        } else if (index >= currentPage.floor() + 1) {
          return Transform.translate(
            offset: Offset(100 * (index.toDouble() - currentPage), 0),
            child: widget.pages[index],
          );
        } else if (index <= currentPage.floor() - 1) {
          return Transform.translate(
            offset: Offset(100 * (currentPage - index.toDouble()), 0),
            child: widget.pages[index],
          );
        } else {
          return widget.pages[index];
        }
      },
    );
  }
}
