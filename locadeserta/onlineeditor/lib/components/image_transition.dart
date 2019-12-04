import 'package:flutter/widgets.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:onlineeditor/animations/fade_images.dart';
import 'package:onlineeditor/models/background_image.dart';

class ImageTransition extends StatefulWidget {
  final String title;
  final ImageType imageType;

  ImageTransition({@required this.title, @required this.imageType});

  @override
  _ImageTransitionState createState() => _ImageTransitionState();
}

class _ImageTransitionState extends State<ImageTransition> {
  AssetImage image;
  AssetImage coloredImage;

  @override
  void initState() {
    super.initState();
    BackgroundImage.nextRandomForType(ImageType.LANDING);
    image = BackgroundImage.getAssetImageForType(ImageType.LANDING);
    coloredImage =
        BackgroundImage.getColoredAssetImageForType(ImageType.LANDING);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: Hero(
        tag: "CatalogView" + widget.title,
        child: TweenImage(
          first: image,
          last: coloredImage,
          duration: 4,
          repeat: false,
        ),
      ),
    );
  }
}
