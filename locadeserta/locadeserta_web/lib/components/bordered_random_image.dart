import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';
import 'package:locadeserta_web/animations/fade_images_web.dart';
import 'package:locadeserta_web/models/background_image_web.dart';
import 'package:locadeserta_web/utils/utils.dart';

class BorderedTweenImageByPath extends StatelessWidget {
  final List imagePaths;
  final Size size;

  BorderedTweenImageByPath(this.imagePaths, this.size);

  @override
  Widget build(BuildContext context) {
    var tweenImage = TweenImage(
      repeat: false,
      last: AssetImage(imagePaths[0]),
      first: AssetImage(imagePaths[1]),
      duration: 3,
      imageFit: BoxFit.fitHeight,
    );
    var container = isSmall(size) ? tweenImage : Center(
      child: tweenImage,
    );
    return Container(
      decoration: getDecorationForContainer(context),
      child: container,
    );
  }
}

class BorderedRandomImageByType extends StatelessWidget {
  final ImageType type;

  BorderedRandomImageByType(this.type);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getDecorationForContainer(context),
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
