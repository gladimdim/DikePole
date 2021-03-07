import 'package:flutter/widgets.dart';
import 'package:locadeserta/animations/fade_images.dart';

class ImageTransition extends StatelessWidget {
  final String title;
  final AssetImage image;
  final AssetImage coloredImage;

  ImageTransition(
      {required this.title,
      required this.image,
      required this.coloredImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: Hero(
        tag: "CatalogView" + title,
        child: TweenImage(
          first: image,
          last: coloredImage,
          duration: 4,
          height: MediaQuery.of(context).size.height / 3,
          repeat: false,
        ),
      ),
    );
  }
}
