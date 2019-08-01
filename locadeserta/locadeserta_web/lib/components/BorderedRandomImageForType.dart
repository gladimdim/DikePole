import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/animations/fade_images_web.dart';
import 'package:locadeserta_web/models/background_image_web.dart';

class BorderedRandomImageByType extends StatelessWidget {
  final ImageType type;

  BorderedRandomImageByType(this.type);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 3.0,
        ),
      ),
      child: TweenImage(
        repeat: true,
        duration: 3,
        first: BackgroundImage.getAssetImageForType(type),
        last: BackgroundImage.getColoredAssetImageForType(type),
        imageFit: BoxFit.fitWidth,
      ),
    );
  }
}

class BorderedRandomImageByPath extends StatelessWidget {
  final List imagePaths;

  BorderedRandomImageByPath(this.imagePaths);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 3.0,
        ),
      ),
      child: TweenImage(
        repeat: true,
        duration: 3,
        first: AssetImage(imagePaths[0]),
        last: AssetImage(imagePaths[1]),
        imageFit: BoxFit.fitWidth,
      ),
    );
  }
}