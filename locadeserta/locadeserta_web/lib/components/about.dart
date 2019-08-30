import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';
import 'package:locadeserta_web/components/bordered_random_image.dart';
import 'package:locadeserta_web/models/background_image_web.dart';
import 'package:locadeserta_web/models/localizations_web.dart';
import 'dart:html' as html;
import 'package:locadeserta_web/utils/utils.dart';

class About extends StatelessWidget {
  final LDLocalizations localization;

  About(this.localization);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var landing = BackgroundImage.getRandomImageForType(ImageType.LANDING);
    print("max height: ${heightThird(size)}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(
          child: Text(
            localization.appTitle,
            style: Theme.of(context).textTheme.title,
          ),
        ),
        if (isSmall(size) && isPortrait(size))
          Hero(
            tag: "CossackHero",
            child: BorderedTweenImageByPath(
              [landing.getImagePathColored(), landing.getImagePath()],
              size,
            ),
          )
        else
          LimitedBox(
            maxHeight: heightThird(size),
            child: Center(
              child: Center(
                child: GridView.count(
                  crossAxisCount: smallestDimension(size) < 500 ? 2 : 3,
                  children: List.generate(
                    smallestDimension(size) < 500 ? 2 : 3,
                    (index) {
                      var b1 = BackgroundImage.getRandomImageForType(
                          ImageType.RIVER);
                      b1.nextRandom();
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Hero(
                          tag: "CossackHero",
                          child: BorderedTweenImageByPath(
                            [b1.getImagePath(), b1.getImagePathColored()],
                            size,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            localization.aboutGame,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              onTap: () => html.window.open(
                  "https://play.google.com/store/apps/details?id=gladimdim.locadeserta",
                  "Google Play Link"),
              child: Image(
                width: widthThird(size),
                image: AssetImage(
                  "images/play_store_badge.png",
                ),
              ),
            ),
            InkWell(
              onTap: () => html.window.open(
                  "https://apps.apple.com/ua/app/дике-поле/id1468068398",
                  "App Store Link"),
              child: Image(
                width: widthThird(size),
                image: AssetImage(
                  "images/appstore.png",
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}