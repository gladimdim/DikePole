import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/animations/fade_images.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/models/background_image.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';

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
        repeat: false,
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
  final bool repeat;

  BorderedRandomImageByPath({required this.imagePaths, this.repeat = false});

  @override
  Widget build(BuildContext context) {
    return BorderedContainer(
      child: TweenImage(
        repeat: this.repeat,
        duration: 6,
        first: AssetImage(imagePaths[0]),
        last: AssetImage(imagePaths[1]),
        imageFit: BoxFit.fitWidth,
      ),
    );
  }
}
