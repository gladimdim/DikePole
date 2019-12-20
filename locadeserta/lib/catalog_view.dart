import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/animations/fade_images.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/models/background_image.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/loaders/catalogs.dart';

import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/components/app_bar_custom.dart';

class CatalogViewArguments {
  final CatalogStory catalogStory;
  final Function onReadPressed;
  final Function onDetailPressed;
  final bool expanded;

  CatalogViewArguments({
    this.catalogStory,
    this.onReadPressed,
    this.onDetailPressed,
    this.expanded = false,
  });
}

class CatalogView extends StatefulWidget {
  final CatalogStory catalogStory;
  final Function onReadPressed;
  final Function onDetailPressed;
  final bool expanded;
  final double animationValue;

  @override
  _CatalogViewState createState() => _CatalogViewState();

  CatalogView(
      {this.catalogStory,
      this.onReadPressed,
      this.onDetailPressed,
      this.expanded = false,
      this.animationValue = 0.0});
}

class _CatalogViewState extends State<CatalogView>
    with TickerProviderStateMixin {
  AssetImage image;
  AssetImage coloredImage;

  @override
  void initState() {
    super.initState();
    BackgroundImage.nextRandomForType(ImageType.LANDING);
    image = BackgroundImage.getAssetImageForType(ImageType.LANDING);
    coloredImage =
        BackgroundImage.getColoredAssetImageForType(ImageType.LANDING);
  }

  @override
  Widget build(BuildContext context) {
    var decoration = widget.expanded
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 1),
          );

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        child: Container(
          decoration: decoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (!widget.expanded)
                Container(
                  height: 75,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    widget.catalogStory.title,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 1.0),
                child: Hero(
                  tag: "CatalogView" + widget.catalogStory.title,
                  child: TweenImage(
                    first: image,
                    last: coloredImage,
                    duration: 4,
                    repeat: false,
                    height: widget.expanded ? 200 : null,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!widget.expanded)
                    Flexible(
                      flex: 10,
                      child: BorderedContainer(
                        child: SlideableButton(
                          onPress: widget.onDetailPressed,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                LDLocalizations.showStoryDetails,
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (!widget.expanded)
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
                    child: BorderedContainer(
                      child: SlideableButton(
                        onPress: widget.onReadPressed,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              LDLocalizations.startStory,
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.expanded)
                Flexible(
                    flex: 50,
                    child: _showDetails(widget.catalogStory, context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showDetails(CatalogStory story, BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  Text(
                    LDLocalizations.authors,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  Text(
                    story.author,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 18.0),
                  )
                ],
              ),
            ),
            SizedBox(
              child: Container(
                color: Theme.of(context).primaryColor,
              ),
              height: 2,
            ),
            Text(
              story.description,
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExtractCatalogViewArguments extends StatelessWidget {
  static const routeName = "/story_details";

  Widget build(BuildContext context) {
    final CatalogViewArguments args = ModalRoute.of(context).settings.arguments;

    return NarrowScaffold(
      actions: [
        AppBarObject(
          text: LDLocalizations.labelBack,
          onTap: () => Navigator.pop(context),
        ),
      ],
      title: args.catalogStory.title,
      body: CatalogView(
        catalogStory: args.catalogStory,
        onReadPressed: args.onReadPressed,
        onDetailPressed: args.onDetailPressed,
        expanded: args.expanded,
      ),
    );
  }
}
