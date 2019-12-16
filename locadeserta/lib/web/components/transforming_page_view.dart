import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/components/image_transition.dart';
import 'package:locadeserta/components/revolver_shell.dart';
import 'package:locadeserta/models/background_image.dart';
import 'package:locadeserta/models/catalogs.dart';

class TransformingPageView extends StatefulWidget {
  final Axis scrollDirection;
  final List<CatalogStory> stories;
  final Function(CatalogStory story) onStorySelected;
  final Function(CatalogStory story) onDetailsSelected;

  TransformingPageView({
    this.scrollDirection = Axis.vertical,
    @required this.onStorySelected,
    @required this.onDetailsSelected,
    this.stories,
  });

  @override
  _TransformingPageViewState createState() => _TransformingPageViewState();
}

class _TransformingPageViewState extends State<TransformingPageView> {
  double currentPage = 0.0;
  PageController _pageController;
  Map<CatalogStory, List<AssetImage>> imageWidgets = {};

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

    widget.stories.forEach(
      (story) => imageWidgets.putIfAbsent(
        story,
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
      itemCount: widget.stories.length,
      itemBuilder: (context, index) {
        if (index == currentPage.floor()) {
          return Transform.translate(
            offset: Offset(100 * (currentPage - index.toDouble()), 0),
            child: _buildStoryShell(
                widget.stories[index], currentPage - index.toDouble(), context),
          );
        } else if (index >= currentPage.floor() + 1) {
          return Transform.translate(
            offset: Offset(100 * (index.toDouble() - currentPage), 0),
            child: _buildStoryShell(
                widget.stories[index], currentPage - index.toDouble(), context),
          );
        } else if (index <= currentPage.floor() - 1) {
          return Transform.translate(
            offset: Offset(100 * (currentPage - index.toDouble()), 0),
            child: _buildStoryShell(
                widget.stories[index], currentPage - index.toDouble(), context),
          );
        } else {
          return _buildStoryShell(
              widget.stories[index], currentPage - index.toDouble(), context);
        }
      },
    );
  }

  Widget _buildStoryShell(
      CatalogStory story, double value, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: BorderedContainer(
            child: RevolverShell(
              top: Container(
                height: 75,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  "${story.year}: ${story.title}",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.title.color,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              middle: ImageTransition(
                title: story.title,
                image: imageWidgets[story][0],
                coloredImage: imageWidgets[story][1],
              ),
              bottom: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 10,
                    child: SlideableButton(
                      onPress: () => widget.onDetailsSelected(story),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
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
                      onPress: () => widget.onStorySelected(story),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
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
                ],
              ),
              animationValue: value,
            ),
          ),
        ),
      ),
    );
//      child: CatalogView(
//        catalogStory: story,
//        animationValue: value,
//        onReadPressed: () => widget.onStorySelected(story),
//        onDetailPressed: () {
//          Navigator.pushNamed(
//            context,
//            "/story_details",
//            arguments: CatalogViewArguments(
//              expanded: true,
//              catalogStory: story,
//              onReadPressed: () => widget.onStorySelected(story),
//              onDetailPressed: () {
//                Navigator.pop(context);
//              },
//            ),
//          );
//        },
//      ),
//    );
  }
}
