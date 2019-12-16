import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/components/image_transition.dart';
import 'package:locadeserta/components/revolver_shell.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/background_image.dart';

class TransformingPageView<T> extends StatefulWidget {
  final Axis scrollDirection;
  final List<T> titles;
  final Function(int index) onStorySelected;
  final Function(int index) onDetailsSelected;

  TransformingPageView({
    this.scrollDirection = Axis.vertical,
    @required this.onStorySelected,
    @required this.onDetailsSelected,
    @required this.titles,
  });

  @override
  _TransformingPageViewState createState() => _TransformingPageViewState();
}

class _TransformingPageViewState extends State<TransformingPageView> {
  double currentPage = 0.0;
  PageController _pageController;
  Map<String, List<AssetImage>> imageWidgets = {};

  void _onScroll() {
    setState(() {
      currentPage = _pageController.page;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8)
      ..addListener(_onScroll);

    widget.titles.forEach(
      (title) => imageWidgets.putIfAbsent(
        title,
        () {
          BackgroundImage.nextRandomForType(ImageType.LANDING);
          return [
            BackgroundImage.getAssetImageForType(ImageType.LANDING),
            BackgroundImage.getColoredAssetImageForType(ImageType.LANDING)
          ];
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: widget.scrollDirection,
      controller: _pageController,
      itemCount: widget.titles.length,
      itemBuilder: (context, index) {
        if (index == currentPage.floor()) {
          return Transform.translate(
            offset: Offset(100 * (currentPage - index.toDouble()), 0),
            child: _buildStoryShell(widget.titles[index],
                currentPage - index.toDouble(), context, index),
          );
        } else if (index >= currentPage.floor() + 1) {
          return Transform.translate(
            offset: Offset(100 * (index.toDouble() - currentPage), 0),
            child: _buildStoryShell(widget.titles[index],
                currentPage - index.toDouble(), context, index),
          );
        } else if (index <= currentPage.floor() - 1) {
          return Transform.translate(
            offset: Offset(100 * (currentPage - index.toDouble()), 0),
            child: _buildStoryShell(widget.titles[index],
                currentPage - index.toDouble(), context, index),
          );
        } else {
          return _buildStoryShell(widget.titles[index],
              currentPage - index.toDouble(), context, index);
        }
      },
    );
  }

  Widget _buildStoryShell(
      String title, double value, BuildContext context, int index) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: BorderedContainer(
            child: RevolverShell(
              top: BorderedContainer(
                child: Container(
                  height: 75,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.title.color,
                      backgroundColor: Theme.of(context).backgroundColor,
                    ),
                  ),
                ),
              ),
              middle: ImageTransition(
                title: title,
                image: imageWidgets[title][0],
                coloredImage: imageWidgets[title][1],
              ),
              bottom: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 10,
                    child: SlideableButton(
                      onPress: () {
                        debugPrint("index selected: ${index}");
                        widget.onDetailsSelected(index);
                      },
                      child: BorderedContainer(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              LDLocalizations.showStoryDetails,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.title.color,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                        height: 50.0,
                        child: Container(
                          color: Theme.of(context).backgroundColor,
                        )),
                  ),
                  Flexible(
                    flex: 10,
                    child: SlideableButton(
                      onPress: () => widget.onStorySelected(index),
                      child: BorderedContainer(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              LDLocalizations.startStory,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.title.color,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              animationValue: value,
            ),
          ),
        ),
      ),
    );
  }
}
