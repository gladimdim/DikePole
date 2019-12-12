import 'package:flutter/material.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';

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
    return DropdownButton<ImageType>(
      value: widget.imageType,
      style: Theme.of(context).textTheme.button,
      onChanged: (newType) {
        widget.onSelected(newType);
      },
      items: imageTypes.map<DropdownMenuItem<ImageType>>((imageType) {
        return DropdownMenuItem(
          value: imageType,
          child: Text(
            imageTypeToString(imageType),
          ),
        );
      }).toList(),
    );
  }
}
