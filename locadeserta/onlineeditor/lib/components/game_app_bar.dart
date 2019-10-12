import 'package:flutter/material.dart';
import 'package:onlineeditor/components/app_bar_custom.dart';

class GameAppBar extends StatelessWidget {
  final VoidCallback onResetStory;
  final VoidCallback onExportStory;
  final String title;

  GameAppBar({this.onResetStory, this.onExportStory, @required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBarCustom(
      title: title,
      appBarButtons: [
      ],
    );
  }
}
