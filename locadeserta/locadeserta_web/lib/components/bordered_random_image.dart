import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';
import 'package:locadeserta_web/animations/fade_images_web.dart';
import 'package:locadeserta_web/utils/utils.dart';

class BorderedRandomImageByPath extends StatelessWidget {
  final List imagePaths;
  final Size size;

  BorderedRandomImageByPath(this.imagePaths, this.size);

  @override
  Widget build(BuildContext context) {
    var tweenImage = TweenImage(
      repeat: true,
      last: AssetImage(imagePaths[0]),
      first: AssetImage(imagePaths[1]),
      duration: 3,
      height: isPortrait(size) ? heightThird(size) : widthThird(size),
      imageFit: !isPortrait(size) ? BoxFit.fitHeight : BoxFit.fitWidth,
    );
    var container = isSmall(size) ? tweenImage : Center(
      child: tweenImage,
    );
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 3.0,
        ),
      ),
      child: container,
    );
  }
}