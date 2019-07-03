import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/animations/fade_images.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/models/background_image.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/catalogs.dart';
import 'package:locadeserta/radiuses.dart';

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

  @override
  _CatalogViewState createState() => _CatalogViewState();

  CatalogView({
    this.catalogStory,
    this.onReadPressed,
    this.onDetailPressed,
    this.expanded = false,
  });
}

class _CatalogViewState extends State<CatalogView>
    with TickerProviderStateMixin {
  Future _future = Future.delayed(Duration(milliseconds: 10));

  @override
  Widget build(BuildContext context) {
    BackgroundImage.nextRandomForType(ImageType.LANDING);
    var image = BackgroundImage.getAssetImageForType(ImageType.LANDING);
    var coloredImage =
        BackgroundImage.getColoredAssetImageForType(ImageType.LANDING);
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 1),
                  borderRadius: getAllRoundedBorderRadius()),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 500,
                    height: 75,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: getTopRoundedBorderRadius(),
                    ),
                    child: Text(
                      widget.catalogStory.title,
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.title.color,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Hero(
                    tag: "CatalogView" + widget.catalogStory.title,
                    child: TweenImage(
                      first: image,
                      last: coloredImage,
                      duration: 4,
                      repeat: true,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!widget.expanded)
                        Flexible(
                          flex: 10,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                              ),
                              onTap: widget.onDetailPressed,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  LDLocalizations.of(context).showStoryDetails,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).textTheme.title.color,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
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
//                              width: 1.0,
                              height: 50.0,
                              child: Container(
                                color: Theme.of(context).backgroundColor,
                              )),
                        ),
                      Flexible(
                        flex: 10,
                        child: SlideableButton(
                          onPress: widget.onReadPressed,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: widget.expanded
                                  ? null
                                  : BorderRadius.only(
                                      bottomRight: Radius.circular(20.0),
                                    ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                LDLocalizations.of(context).startStory,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).textTheme.title.color,
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
                  if (widget.expanded) _showDetails(widget.catalogStory),
                ],
              ),
            ),
          ),
    );
  }

  Widget _showDetails(CatalogStory story) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            story.description,
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
        ),
      ),
    );
  }
}

class ExtractCatalogViewArguments extends StatelessWidget {
  static const routeName = "/story_details";

  Widget build(BuildContext context) {
    final CatalogViewArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(args.catalogStory.title),
        ),
        body: CatalogView(
          catalogStory: args.catalogStory,
          onReadPressed: args.onReadPressed,
          onDetailPressed: args.onDetailPressed,
          expanded: args.expanded,
        ));
  }
}
