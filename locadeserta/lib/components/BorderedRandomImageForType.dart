import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/animations/fade_images.dart';
import 'package:locadeserta/models/background_image.dart';

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