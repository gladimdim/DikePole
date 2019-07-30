import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';
import 'package:locadeserta_web/animations/fade_images_web.dart';
import 'package:locadeserta_web/models/background_image_web.dart';
import 'package:locadeserta_web/models/localizations_web.dart';
import 'dart:html' as html;

class About extends StatelessWidget {
  final LDLocalizations localization;

  About(this.localization);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Center(
          child: Text(
            localization.appTitle,
            style: Theme.of(context).textTheme.title,
          ),
        ),
        LimitedBox(
          maxHeight: size.height / 5,
          child: Center(
            child: Center(
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(
                  3,
                  (index) {
                    var b1 =
                        BackgroundImage.getRandomImageForType(ImageType.RIVER);
                    b1.nextRandom();
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Hero(
                        tag: "CossackHero",
                        child: TweenImage(
                          repeat: true,
                          last: b1.getAssetImageColored(),
                          first: b1.getAssetImage(),
                          duration: 3,
                          height: size.height / 3,
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
        InkWell(
          onTap: () => html.window.open("https://play.google.com/store/apps/details?id=gladimdim.locadeserta", "Google Play Link"),
          child: Image(
            height: 60,
            image: AssetImage(
              "images/play_store_badge.png",
            ),
          ),
        ),
        InkWell(
          onTap: () => html.window.open("https://apps.apple.com/ua/app/дике-поле/id1468068398", "App Store Link"),
          child: Image(
            height: 60,
            image: AssetImage(
              "images/appstore.png",
            ),
          ),
        )
      ],
    );
  }
}
