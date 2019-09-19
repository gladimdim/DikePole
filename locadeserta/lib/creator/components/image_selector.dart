import 'package:flutter/material.dart';
import 'package:locadeserta/models/background_image.dart';

class ImageSelector extends StatefulWidget {
  final ImageType imageType;
  final Function(ImageType) onSelected;

  ImageSelector({this.imageType = ImageType.RIVER, this.onSelected});

  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  List<ImageType> imageTypes = const <ImageType>[
    ImageType.BOAT,
    ImageType.BULRUSH,
    ImageType.CAMP,
    ImageType.RIVER,
    ImageType.COSSACKS,
    ImageType.STEPPE,
    ImageType.LANDING,
    ImageType.FOREST,
  ];

  @override
  Widget build(BuildContext context) {
    print("image type: ${widget.imageType}");
    return DropdownButton<ImageType>(
      value: widget.imageType,
      onChanged: (newType) {
        widget.onSelected(newType);
      },
      items: imageTypes.map<DropdownMenuItem<ImageType>>((imageType) {
        return DropdownMenuItem(
          value: imageType,
          child: Text(imageTypeToString(imageType)),
        );
      }).toList(),
    );
  }
}
