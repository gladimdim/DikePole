import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/animations/TweenImage.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/models/BackgroundImage.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/catalogs.dart';
import 'package:locadeserta/radiuses.dart';

class CatalogView extends StatefulWidget {
  final CatalogStory catalogStory;
  final Function onPressed;

  @override
  _CatalogViewState createState() => _CatalogViewState();

  CatalogView({this.catalogStory, this.onPressed});
}

class _CatalogViewState extends State<CatalogView>
    with TickerProviderStateMixin {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    BackgroundImage.nextRandomForType(ImageType.LANDING);
    var image = BackgroundImage.getAssetImageForType(ImageType.LANDING);
    var coloredImage =
        BackgroundImage.getColoredAssetImageForType(ImageType.LANDING);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: AnimatedSize(
        curve: Curves.linear,
        vsync: this,
        duration: Duration(milliseconds: 800),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: getAllRoundedBorderRadius()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                  borderRadius: getTopRoundedBorderRadius(),
                  child: TweenImage(
                    first: image,
                    last: coloredImage,
                    duration: 4,
                    repeat: true,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 10,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: expanded ? Colors.white : Colors.black,
                        borderRadius: expanded
                            ? null
                            : BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                              ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            expanded = !expanded;
                          });
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.catalogStory.title,
                            style: TextStyle(
                              color: expanded
                                  ? Colors.black
                                  : Theme.of(context).textTheme.title.color,
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
                        width: 5.0,
                        height: 50.0,
                        child: Container(
                          color: Colors.white,
                        )),
                  ),
                  Flexible(
                    flex: 10,
                    child: SlideableButton(
                      onPress: widget.onPressed,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: expanded
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
              if (expanded) _showDetails(widget.catalogStory),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showDetails(CatalogStory story) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        story.description,
        style: TextStyle(
          fontSize: 15.0,
        ),
      ),
    );
  }
}
