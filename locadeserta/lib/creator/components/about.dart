import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/components/BorderedRandomImageForType.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/creator/utils/utils.dart';
import 'package:locadeserta/models/background_image.dart';

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
            LDLocalizations.appTitle,
            style: Theme.of(context).textTheme.title,
          ),
        ),
        if (isSmall(size) && isPortrait(size))
          Hero(
            tag: "CossackHero",
            child: BorderedRandomImageByPath(
              [landing.getImagePathColored(), landing.getImagePath()],
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
                          child: BorderedRandomImageByPath(
                            [b1.getImagePath(), b1.getImagePathColored()],
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
            LDLocalizations.aboutGame,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              onTap: () { print("tapped store"); },
              child: Image(
                width: widthThird(size),
                image: AssetImage(
                  "images/play_store_badge.png",
                ),
              ),
            ),
            InkWell(
              onTap: () { print("Open link"); },
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
